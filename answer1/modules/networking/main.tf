resource "azurerm_resource_group" "azure-stack-rs" {
  for_each = {for rg in var.resource_group : rg.name => rg}
  name     = each.value.name
  location = each.value.location
}

resource "azurerm_virtual_network" "vnet01" {
  for_each = {for vnet in var.vnet : vnet.name => vnet}
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  address_space       = each.value.cidr
}

locals{
  subnet_list = flatten([for vnet in var.vnet: [for snet in vnet.subnets :
   { vnet_name = vnet.name, rg_name = vnet.resource_group_name, subnet_name = snet.name, subnet_cidr = snet.cidr}]])
}

resource "azurerm_subnet" "subnet" {
  for_each = {for subnet in local.subnet_list : subnet.subnet_cidr => subnet}
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = veach.value.rg_name
  address_prefixes     = [each.value.suubnet_cidr]
}

resource "azurerm_network_security_group" "web" {
  name                = "web-nsg"
  location            = "East.US.2"
  resource_group_name = "vnet-rg"
  
  security_rule {
    name                       = "ssh-rule-1"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
  }
  
  security_rule {
    name                       = "ssh-rule-2"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_address_prefix      = "192.168.3.0/24"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
}
}

resource "azurerm_subnet_network_security_group_association" "websubnet-webnsg" {
  subnet_id                 = azurerm_subnet.subnet[web-subnet].id
  network_security_group_id = azurerm_network_security_group.web.id
}


resource "azurerm_network_security_group" "app" {
    name = "app-nsg"
    location            = "East.US.2"
    resource_group_name = "vnet-rg"

    security_rule {
        name = "ssh-rule-1"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_address_prefix = "192.168.1.0/24"
        source_port_range = "*"
        destination_address_prefix = "*"
        destination_port_range = "22"
    }
    
    security_rule {
        name = "ssh-rule-2"
        priority = 101
        direction = "Outbound"
        access = "Allow"
        protocol = "Tcp"
        source_address_prefix = "192.168.1.0/24"
        source_port_range = "*"
        destination_address_prefix = "*"
        destination_port_range = "22"
    }
}

resource "azurerm_subnet_network_security_group_association" "appsubnet-appnsg" {
  subnet_id                 = azurerm_subnet.subnet[app-subnet].id
  network_security_group_id = azurerm_network_security_group.app.id
}


resource "azurerm_network_security_group" "database-nsg" {
    name = "db-nsg"
    location            = "East.US.2"
    resource_group_name = "vnet-rg"

    security_rule {
        name = "ssh-rule-1"
        priority = 101
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_address_prefix = "192.168.2.0/24"
        source_port_range = "*"
        destination_address_prefix = "*"
        destination_port_range = "3306"
    }
    
    security_rule {
        name = "ssh-rule-2"
        priority = 102
        direction = "Outbound"
        access = "Allow"
        protocol = "Tcp"
        source_address_prefix = "192.168.2.0/24"
        source_port_range = "*"
        destination_address_prefix = "*"
        destination_port_range = "3306"
    }
    
    security_rule {
        name = "ssh-rule-3"
        priority = 100
        direction = "Outbound"
        access = "Deny"
        protocol = "Tcp"
        source_address_prefix = "192.168.1.0/24"
        source_port_range = "*"
        destination_address_prefix = "*"
        destination_port_range = "3306"
    }
}

resource "azurerm_subnet_network_security_group_association" "db-nsg-subnet" {
  subnet_id                 = azurerm_subnet.subnet[db-subnet].id
  network_security_group_id = azurerm_network_security_group.db-nsg.id
}

resource "azurerm_sql_server" "db_server" {
    name = "PrimaryDB"
    resource_group_name = "test-rg"
    location = "East US 2"
    version = 13.0
    administrator_login = "admin"
    administrator_login_password = "Password123!"
}

resource "azurerm_sql_database" "database" {
  name                = "db"
  resource_group_name = "test-rg"
  location            = "East US 2"
  server_name         = azurerm_sql_server.db_server.name
}

resource "azurerm_network_interface" "nic" {
  or_each = {for vm in var.VM : vm.name => vm}
    name = each.value.name
    resource_group_name = each.value.resource_group_name
    location = var.location

    ip_configuration{
        name = each.value.name
        subnet_id = each.value.subnet_id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_windows_virtual_machine" "vm" {
  for_each = {for vm in var.VM : vm.name => vm}
  name = each.value.name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  network_interface_ids = [ azurerm_network_interface.nic[each.value.name].id ]
  vm_size = each.value.vm_size
  delete_os_disk_on_termination = true
  
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name = "app-disk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = each.value.hostname
    admin_username = each.value.username
    admin_password = each.value.password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

