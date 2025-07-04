data "azurerm_key_vault" "key_valut" {
  name                = var.key_valut_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "administrator_login" {
  name         = var.secret_data_base
  key_vault_id = data.azurerm_key_vault.key_valut.id
}
data "azurerm_key_vault_secret" "administrator_login_password" {
  name         = var.secret_admin_pass
  key_vault_id = data.azurerm_key_vault.key_valut.id
}