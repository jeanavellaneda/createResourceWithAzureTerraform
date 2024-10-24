variable "base_name" {
    type = string
    description = "The storage account base name"
}

variable "resource_group_name" {
    type = string
    description = "Name of the resource group"
}

variable "location" {
    type = string
    description = "The location for the deployment"
}

variable "connection_string_blob_service" {
    type = string
    description = "connection_string_blob_service"
}

variable "blob_container_name" {
    type = string
    description = "blob_container_name"
}

variable "datalake_name" {
    type = string
    description = "datalake_name"
}

variable "datalake_storage_account" {
    type = string
    description = "datalake_storage_account"
}