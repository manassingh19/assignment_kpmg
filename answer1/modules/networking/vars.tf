variable "resource_group"{
    type = list(objects({
        name = string
        location = string
    }
))
}

variable "VNET"{
    type = list(objects({
        name = string
    cidr = string
    location = string
    resource_group_name = string
    subnets = list(objects({
        name = string
        cidr = string
    }))
    }
))
}

variable "VM"{
    type = list(objects({
     name = string
     location = string
     resource_group_name = string
     subnet_id = string
     vm_size = string
     hostname = string
     username = string
     password = string

    }
        
    ))
}