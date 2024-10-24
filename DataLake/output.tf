output "dl_name_out" {
    value = resource.azurerm_storage_account.data_lake_account.name
}

output "dl_account_key" {
  value = resource.azurerm_storage_account.data_lake_account.primary_access_key
  sensitive = true
}
