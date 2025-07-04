resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = data.azurerm_key_vault_secret.administrator_login.value
  administrator_login_password = data.azurerm_key_vault_secret.administrator_login_password.value
  minimum_tls_version          = "1.2"
}


