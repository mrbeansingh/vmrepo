resource "azurerm_network_interface" "nic" {
  name                = var.nicname
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnetdata.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = data.azurerm_public_ip.pia.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = var.vmname
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = data.azurerm_key_vault_secret.vm-username.value
  admin_password = data.azurerm_key_vault_secret.vm-pass.value
  disable_password_authentication=false
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"

  }
     custom_data = base64encode(<<EOF
#!/bin/bash
# Update and install NGINX
apt-get update -y
apt-get install nginx -y
systemctl start nginx
systemctl enable nginx
EOF
     )
}


