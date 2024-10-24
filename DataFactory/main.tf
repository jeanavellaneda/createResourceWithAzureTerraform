resource "azurerm_data_factory" "adf" {
  name                = var.base_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "blob_storage" {
  name                = "linkedServiceBlobStorage"
  data_factory_id     = azurerm_data_factory.adf.id
  connection_string   = var.connection_string_blob_service
}

resource "azurerm_data_factory_dataset_delimited_text" "csv_dataset" {
  name                = "ds_covid_population_bs"
  data_factory_id     = azurerm_data_factory.adf.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.blob_storage.name

  azure_blob_storage_location {
    container = var.blob_container_name 
    filename  = "data.csv"
  }

  column_delimiter = ","
  encoding         = "utf-8"
  escape_character = "\\"
  first_row_as_header = true
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "data_lake" {
  name            = "linkedServiceDataLake"
  data_factory_id = azurerm_data_factory.adf.id
  url             = "https://${var.datalake_name}.dfs.core.windows.net/"
  storage_account_key = var.datalake_storage_account
}

resource "azurerm_data_factory_dataset_delimited_text" "bronze_csv" {
  name                = "ds_covid_population_dl"
  data_factory_id     = azurerm_data_factory.adf.id
  linked_service_name = azurerm_data_factory_linked_service_data_lake_storage_gen2.data_lake.name

  azure_blob_storage_location {
    container = var.datalake_name
    path      = "stgdatalake/bronze/"
    filename  = "data.csv"
  }

  column_delimiter = ","
  row_delimiter = "Default"
  encoding         = "utf-8"
  escape_character = "\\"
  first_row_as_header = true
}

resource "azurerm_data_factory_pipeline" "copy_pipeline" {
  name            = "pipeline_copy_blob_to_datalake"
  data_factory_id = azurerm_data_factory.adf.id

  activities_json = jsonencode([
    {
      "name": "validate file",
      "type": "Validation",
      "dependsOn": [],
      "userProperties": [],
      "typeProperties": {
          "dataset": {
              "referenceName": "ds_covid_population_bs",
              "type": "DatasetReference"
          },
          "timeout": "0.00:00:30",
          "sleep": 10
      }
    },
    {
      "name": "Copy_to_bronze",
      "type": "Copy",
      "dependsOn": [
          {
              "activity": "validate file",
              "dependencyConditions": [
                  "Succeeded"
              ]
          }
      ],
      "policy": {
          "timeout": "0.12:00:00",
          "retry": 0,
          "retryIntervalInSeconds": 30,
          "secureOutput": false,
          "secureInput": false
      },
      "userProperties": [],
      "typeProperties": {
          "source": {
              "type": "DelimitedTextSource",
              "storeSettings": {
                  "type": "AzureBlobStorageReadSettings",
                  "recursive": true,
                  "enablePartitionDiscovery": false
              },
              "formatSettings": {
                  "type": "DelimitedTextReadSettings"
              }
          },
          "sink": {
              "type": "DelimitedTextSink",
              "storeSettings": {
                  "type": "AzureBlobFSWriteSettings"
              },
              "formatSettings": {
                  "type": "DelimitedTextWriteSettings",
                  "quoteAllText": true,
                  "fileExtension": ".txt"
              }
          },
          "enableStaging": false,
          "translator": {
              "type": "TabularTranslator",
              "typeConversion": true,
              "typeConversionSettings": {
                  "allowDataTruncation": true,
                  "treatBooleanAsNumber": false
              }
          }
      },
      "inputs": [
        {
          "referenceName": azurerm_data_factory_dataset_delimited_text.csv_dataset.name,
          "type": "DatasetReference"
        }
      ],
      "outputs": [
        {
          "referenceName": azurerm_data_factory_dataset_delimited_text.bronze_csv.name,
          "type": "DatasetReference"
        }
      ],
      "typeProperties": {
        "source": {
          "type": "BlobSource"
        },
        "sink": {
          "type": "BlobSink"
        }
      }
    },
    {
      "name": "BronzeToSilver",
      "type": "DatabricksNotebook",
      "dependsOn": [
          {
              "activity": "Copy_to_bronze",
              "dependencyConditions": [
                  "Succeeded"
              ]
          }
      ],
      "policy": {
          "timeout": "0.12:00:00",
          "retry": 0,
          "retryIntervalInSeconds": 30,
          "secureOutput": false,
          "secureInput": false
      },
      "userProperties": []
    },
    {
      "name": "SilverToGold",
      "type": "DatabricksNotebook",
      "dependsOn": [
          {
              "activity": "BronzeToSilver",
              "dependencyConditions": [
                  "Succeeded"
              ]
          }
      ],
      "policy": {
          "timeout": "0.12:00:00",
          "retry": 0,
          "retryIntervalInSeconds": 30,
          "secureOutput": false,
          "secureInput": false
      },
      "userProperties": []
    }
  ])
}



