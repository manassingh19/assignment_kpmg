#Resource Group
Resource_Group = [{
    name = "test-rg"
    location = "East US 2"
},
{
    name = "vnet-rg"
    location = "East US 2"
}
]

#Networking

VNET = [{
    name = "test-vm"
    cidr = "40.0.1.0/16"
    location = "East US 2"
    resource_group_name = "vnet-rg"
    subnets = [
        {
            name = "web-subnet"
            cidr = "40.0.0.0/17"
        },
        {
            name = "app-subnet"
            cidr = "40.0.128.0/18"
        },
        {
            name = "db-subnet"
            cidr = "40.0.192.0/18"
        }
    ]
},
{
    name = "test-vm"
    cidr = "10.0.0.0/8"
    location = "East US 2"
    resource_group_name = "vnet-rg"
    subnets = [
        {
            name = "web-subnet"
            cidr = "40.0.0.0/17"
        },
        {
            name = "app-subnet"
            cidr = "40.0.128.0/18"
        },
        {
            name = "db-subnet"
            cidr = "40.0.192.0/18"
        }
    ]
}]


VM = [{
     name = "App-Server"
     location = "East US 2"
     resource_group_name = "test-rg"
     subnet_id = "subnet-xxxxx"
     vm_size = "Standardv2_LS"
     hostname = "AppServer"
     username = "admin"
     password = "password123!"

},
{
     name = "Web-Server"
     location = ""
     resource_group_name = ""
     subnet_id = "subnet-xxxxxxx"
     vm_size = "Standardv2_LS"
     hostname = "WebServer"
     username = "admin"
     password = "password123!"

}]


