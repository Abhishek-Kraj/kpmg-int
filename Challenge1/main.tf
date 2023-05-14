# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = "rgs-${var.project}-${var.environment}"
  location = var.location
}

# Virtual network
resource "azurerm_virtual_network" "app_vnet" {
  name                = var.virtual_network_name
  address_space       = var.virtual_network_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "app_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = [var.subnet_address_prefix]
}

# Public IP for frontend load balancer
resource "azurerm_public_ip" "frontend_public_ip" {
  name                = "frontend-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Frontend load balancer
resource "azurerm_lb" "frontend_lb" {
  name                = "frontend-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "frontend-lb-ipconfig"
    public_ip_address_id = azurerm_public_ip.frontend_public_ip.id
  }
}

# Backend pool for frontend load balancer
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name                = "backend-pool"
  loadbalancer_id     = azurerm_lb.frontend_lb.id
  resource_group_name = azurerm_resource_group.rg.name
}

# Virtual machine for the frontend
resource "azurerm_linux_virtual_machine" "frontend_vm" {
  name                = "frontend-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.frontend_nic.id
  ]

  os_disk {
    name              = "frontend-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Network interface for the frontend
resource "azurerm_network_interface" "frontend_nic" {
  name                = "frontend-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "frontend-nic-ipconfig"
    subnet_id                     = azurerm_subnet.frontend_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.frontend_public_ip.id
  }
}

# Database server
resource "azurerm_mssql_server" "database_server" {
  name                         = "kpmg-database-server"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  version                      = "12.0"
    administrator_login          = "adminuser"
  administrator_login_password = "password"

  sku {
    name     = "GP_Gen5_2"
    tier     = "GeneralPurpose"
    capacity = 2
    family   = "Gen5"
    size     = "GP_Gen5_2"
  }
}

# Output the frontend IP address
output "frontend_ip" {
  value = azurerm_public_ip.frontend_public_ip.ip_address
}

# Output the database server fully qualified domain name
output "database_server_fqdn" {
  value = azurerm_mssql_server.database_server.fully_qualified_domain_name
}

