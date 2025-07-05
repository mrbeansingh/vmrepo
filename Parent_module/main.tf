module "resouregroup" {
  source   = "../Child_module/azurerm_resoure_group"
  name     = "rg-vm"
  location = "centralindia"

  

}
module "resouregroup" {
  source   = "../Child_module/azurerm_resoure_group"
  name     = "arv-vm"
  location = "centralindia"
}

module "resouregroup1" {
  source   = "../Child_module/azurerm_resoure_group"
  name     = "rg-vm1"
  location = "centralindia"
  
}

module "resouregroup2" {
  source   = "../Child_module/azurerm_resoure_group"
  name     = "rg-vm2"
  location = "centralindia"
  
}



module "vnet" {
  depends_on          = [module.resouregroup]
  source              = "../Child_module/azurerm_virtual_network"
  vnetname            = "rg-ventvm"
  location            = "centralindia"
  resource_group_name = "rg-vm"
  address_space       = ["10.0.0.0/16"]
}
module "subnet" {
  depends_on           = [module.vnet]
  source               = "../Child_module/azurerm_subent"
  subnetname           = "subnetvmabhay"
  resource_group_name  = "rg-vm"
  virtual_network_name = "rg-ventvm"
  address_prefixes     = ["10.0.1.0/24"]

}
module "subnet1" {
  depends_on           = [module.vnet]
  source               = "../Child_module/azurerm_subent"
  subnetname           = "subnetsingh"
  resource_group_name  = "rg-vm"
  virtual_network_name = "rg-ventvm"
  address_prefixes     = ["10.0.2.0/24"]
}


module "pip" {
  depends_on = [module.resouregroup]

  source              = "../Child_module/azurerm_public_ip"
  public_ip_name      = "pipforvm"
  resource_group_name = "rg-vm"
  location            = "centralindia"
  allocation_method   = "Static"
}

module "sql_server" {
  depends_on          = [module.resouregroup, module.data-user, module.data-pass]
  source              = "../Child_module/azurerm_sql_server"
  sql_server_name     = "abhaysqlserver"
  resource_group_name = "rg-vm"
  location            = "centralindia"
  key_valut_name      = "abhay-key-valut"
  secret_data_base    = "data-username"
  secret_admin_pass   = "data-password"

}

module "sql_database" {
  depends_on          = [module.sql_server]
  source              = "../Child_module/azurerm_database"
  sql_server_name     = "abhaysqlserver"
  resource_group_name = "rg-vm"
  datbase_name        = "abhay-database"
}

module "key_valuts" {
  depends_on          = [module.resouregroup]
  source              = "../Child_module/azurerm_keyvalut"
  key_valut_name      = "abhay-key-valut"
  location            = "centralindia"
  resource_group_name = "rg-vm"
}

module "vm-user" {
  depends_on          = [module.key_valuts]
  source              = "../Child_module/azurerm_key_secrets"
  secret_name         = "vm-username"
  secret_value        = var.vmuser_secrets
  key_valut_name      = "abhay-key-valut"
  resource_group_name = "rg-vm"
}

module "vm-pass" {
  depends_on          = [module.key_valuts]
  source              = "../Child_module/azurerm_key_secrets"
  secret_name         = "vm-password"
  secret_value        = var.vmpass_secrets
  key_valut_name      = "abhay-key-valut"
  resource_group_name = "rg-vm"
}

module "data-user" {
  depends_on          = [module.key_valuts]
  source              = "../Child_module/azurerm_key_secrets"
  secret_name         = "data-username"
  secret_value        = var.admin_username
  key_valut_name      = "abhay-key-valut"
  resource_group_name = "rg-vm"
}
module "data-pass" {
  depends_on          = [module.key_valuts]
  source              = "../Child_module/azurerm_key_secrets"
  secret_name         = "data-password"
  secret_value        = var.admin_password
  key_valut_name      = "abhay-key-valut"
  resource_group_name = "rg-vm" 
}





module "virtual_vm" {
  depends_on           = [module.resouregroup, module.vm-user, module.vm-pass, module.key_valuts, module.pip, module.subnet]
  source               = "../Child_module/azurerm_virtual_machine"
  nicname              = "nicvm"
  location             = "centralindia"
  resource_group_name  = "rg-vm"
  vmname               = "vmnewfrontend"
  size                 = "Standard_F2"
  admin_username       = "vm-username"
  admin_password       = "vm-password"
  publisher            = "Canonical"
  offer                = "0001-com-ubuntu-server-jammy"
  sku                  = "22_04-lts"
  subnetname           = "subnetvmabhay"
  virtual_network_name = "rg-ventvm"
  pulicip_name         = "pipforvm"
  keyvalutname         =  "abhay-key-valut"

}