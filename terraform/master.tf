locals {
  # https://kubernetes.io/docs/reference/networking/ports-and-protocols/#control-plane
  master_node_network_rules = {
    "22" = {
      name      = "SSH"
      priority  = 1001
      direction = "Inbound"
    }
    "6443" = {
      name      = "Kubernetes-API-server"
      priority  = 2001
      direction = "Inbound"
    }
    "2379-2380" = {
      name      = "etcd-server-client-API"
      priority  = 2002
      direction = "Inbound"
    }
    "10250" = {
      name      = "Kubelet-API"
      priority  = 2003
      direction = "Inbound"
    }
    "10259" = {
      name      = "kube-scheduler"
      priority  = 2004
      direction = "Inbound"
    }
    "10257" = {
      name      = "kube-controller-manager"
      priority  = 2005
      direction = "Inbound"
    }
  }
}

resource "azurerm_network_security_group" "master_nsg" {
  name                = "k8s-cluster-master-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

resource "azurerm_network_security_rule" "master_nsg_rules" {
  for_each = local.master_node_network_rules

  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.master_nsg.name
  destination_port_range      = each.key
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

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
  network_security_group_id = azurerm_network_security_group.master_nsg.id
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
