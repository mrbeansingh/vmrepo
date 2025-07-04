resource "azurerm_mssql_database" "database" {
  name           = var.datbase_name
  server_id      = data.azurerm_mssql_server.database.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 250
  sku_name       = "S0"


}
