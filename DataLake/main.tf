resource "azurerm_storage_account" "data_lake_account" {
    name = lower(var.base_name)
    resource_group_name = var.resource_group_name
    location = var.location 
    account_tier = "Standard"
    account_replication_type = "LRS"
    account_kind = "StorageV2"
    is_hns_enabled = true
    enable_https_traffic_only = true
    access_tier = "Hot"
    allow_nested_items_to_be_public = false
}

resource "azurerm_storage_data_lake_gen2_filesystem" "data_lake" {
    name = lower(var.dlgen2_name)
    storage_account_id = azurerm_storage_account.data_lake_account.id
    properties = {
        hello = "aGVsbG8="
    }
}

resource "azurerm_storage_data_lake_gen2_path" "bronze" {
  storage_account_id = azurerm_storage_account.data_lake_account.id
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.data_lake.name
  path               = "bronze"
  resource           = "directory"
}

resource "azurerm_storage_data_lake_gen2_path" "silver" {
  storage_account_id = azurerm_storage_account.data_lake_account.id
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.data_lake.name
  path               = "silver"
  resource           = "directory"
}

resource "azurerm_storage_data_lake_gen2_path" "gold" {
  storage_account_id = azurerm_storage_account.data_lake_account.id
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.data_lake.name
  path               = "gold"
  resource           = "directory"
}