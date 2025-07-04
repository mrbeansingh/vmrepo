data "azurerm_subnet" "subnetdata" {
  name                 = var.subnetname
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_public_ip" "pia" {
  name                = var.pulicip_name
  resource_group_name = var.resource_group_name
}
data "azurerm_key_vault" "keyval" {
  name                = var.keyvalutname
  resource_group_name = var.resource_group_name
}

  data "azurerm_key_vault_secret" "vm-username" {
  name         = var.admin_username
  key_vault_id = data.azurerm_key_vault.keyval.id
}
data "azurerm_key_vault_secret" "vm-pass" {
  name         = var.admin_password
  key_vault_id = data.azurerm_key_vault.keyval.id
}


