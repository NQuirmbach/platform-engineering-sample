resource "azurerm_public_ip" "master_public_ip" {
  name                = "k8s-cluster-master-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  tags                = local.tags
}

resource "azurerm_network_interface" "master_nic" {
  name                = "k8s-cluster-master-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.master_public_ip.id
  }
  tags = local.tags
}
resource "azurerm_network_interface_security_group_association" "master_nic_nsg" {
  network_interface_id      = azurerm_network_interface.master_nic.id
  network_security_group_id = azurerm_network_security_group.nsg
}

resource "azurerm_linux_virtual_machine" "master" {
  name                = "k8s-cluster-master"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.cluster_master_vm_size
  admin_username      = local.vm_admin_user

  network_interface_ids = [
    azurerm_network_interface.master_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  admin_ssh_key {
    username   = local.vm_admin_user
    public_key = var.cluster_ssh_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  tags = local.tags
}
