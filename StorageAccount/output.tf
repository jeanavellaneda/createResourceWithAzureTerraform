output "sa_name_out" {
    value = resource.azurerm_storage_account.blob_storage_account.name
}

output "sa_primary_connection_string" {
  value = azurerm_storage_account.blob_storage_account.primary_connection_string
}

output "sa_blob_container_name" {
  value = azurerm_storage_container.blob_container.name
}