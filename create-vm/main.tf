resource "azurerm_resource_group" "tf_resoruce_group" {
  name     = "vm-group"
  location = "West Europe"
}

resource "azurerm_virtual_network" "tf_network" {
  name                = "private-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tf_resoruce_group.location
  resource_group_name = azurerm_resource_group.tf_resoruce_group.name
}

resource "azurerm_subnet" "tf_subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.tf_resoruce_group.name
  virtual_network_name = azurerm_virtual_network.tf_network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "tf_network_interface" {
  name                = "private-nic"
  location            = azurerm_resource_group.tf_resoruce_group.location
  resource_group_name = azurerm_resource_group.tf_resoruce_group.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "tf_virtual_machine" {
  name                = "jenkins-server"
  resource_group_name = azurerm_resource_group.tf_resoruce_group.name
  location            = azurerm_resource_group.tf_resoruce_group.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "User@1234"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.tf_network_interface.id,
  ]
    # admin_ssh_key {
    #     username   = "adminuser"
    #     public_key = file("~/.ssh/id_rsa.pub")
    # }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}