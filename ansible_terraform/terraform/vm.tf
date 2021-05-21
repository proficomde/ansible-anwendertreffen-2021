# Create resource group

resource "azurerm_resource_group" "RG" {
  name     = var.azurerm_resource_group
  location = var.location
}

# Create key pair

resource "tls_private_key" "key" {
  algorithm = "RSA"
}

# Networking

resource "azurerm_virtual_network" "vnet" {
  name                = "vnetvm"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name
  address_space       = ["11.0.0.0/16"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["11.0.1.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  count                   = var.number_of_vms
  name                    = "pub_ip_${count.index}"
  location                = var.location
  resource_group_name     = azurerm_resource_group.RG.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30
}

resource "azurerm_network_interface" "nic_vm" {
  count               = var.number_of_vms
  name                = "nic_vm_${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name

  ip_configuration {
    name                          = "ip_vm_${count.index}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  count                     = var.number_of_vms
  network_interface_id      = azurerm_network_interface.nic_vm[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Virtual Machines

resource "azurerm_linux_virtual_machine" "vm_tf" {
  count               = var.number_of_vms
  name                = "vmantf-${count.index}"
  resource_group_name = azurerm_resource_group.RG.name
  location            = var.location
  size                = var.vm_size
  admin_username      = "ansibleuser"
  network_interface_ids = [
    azurerm_network_interface.nic_vm[count.index].id
  ]

  admin_ssh_key {
    username   = "ansibleuser"
    public_key = tls_private_key.key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}

# Create local private key

resource "local_file" "private_key" {
  content  = tls_private_key.key.private_key_pem
  filename = "${path.module}/ans_tf_id_rsa"
  file_permission = "0600"
}