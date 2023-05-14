project     = "kmpmg"
environment = "dev"
location    = "West Europe"
prefix      = "az0kn"
tags = {
  environment = "development"
  owner       = "John Doe"
  costcenter  = "12345"
}
virtual_network_name         = "kpmg-app-vnet"
virtual_network_address_space = ["10.0.0.0/16"]
subnet_name                  = "frontend-subnet"
subnet_address_prefix        = "10.0.1.0/24"
