data "azurerm_key_vault" "keyvalut" {
  name                = var.key_valut_name
  resource_group_name = var.resource_group_name
}