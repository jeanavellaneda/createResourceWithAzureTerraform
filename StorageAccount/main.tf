resource "azurerm_storage_account" "blob_storage_account" {
    name = lower(var.base_name)
    resource_group_name = var.resource_group_name
    location = var.location 
    account_tier = "Standard"
    account_replication_type = "LRS"
    account_kind = "BlobStorage"
    enable_https_traffic_only = true
    access_tier = "Hot"
    allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "blob_container" {
  name                  = "blobcontainer"
  storage_account_name  = azurerm_storage_account.blob_storage_account.name
  container_access_type = "private"
}
