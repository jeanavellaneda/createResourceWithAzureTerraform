terraform {
    required_providers {
        azurerm = {
            source ="hashicorp/azurerm"
            version = "~>3.0"
        }
        random = {
            source  = "hashicorp/random"
            version = "~>3.0"
        }
        databricks = {
            source  = "databricks/databricks"
            version = "~> 1.40.0"
        }
    }
}
provider "azurerm" {
    features {

    }
}

module "ResourceGroup" {
    source = "./ResourceGroup"
    base_name = "RG_ETL_AZURE_TERRAFORM"
    location = "eastus2"
}

module "StorageAccount" {
    source = "./StorageAccount"
    base_name = "covidblobstoragefile"
    resource_group_name = module.ResourceGroup.rg_name_out
    location = module.ResourceGroup.rg_location_out
}

module "DataLake" {
    source = "./DataLake"
    base_name = "coviddatalakev2"
    dlgen2_name = "datalake"
    resource_group_name = module.ResourceGroup.rg_name_out
    location = module.ResourceGroup.rg_location_out
}

module "DataFactory" {
    source = "./DataFactory"
    base_name = "adf-covid-etl-v1"
    resource_group_name = module.ResourceGroup.rg_name_out
    location = module.ResourceGroup.rg_location_out
    connection_string_blob_service = module.StorageAccount.sa_primary_connection_string
    blob_container_name = module.StorageAccount.sa_blob_container_name
    datalake_name = module.DataLake.dl_name_out
    datalake_storage_account = module.DataLake.dl_account_key
}

module "Databricks" {
  source              = "./Databricks"
  base_name           = "dbw-covid-etl"
  resource_group_name = module.ResourceGroup.rg_name_out
  location            = module.ResourceGroup.rg_location_out
}
