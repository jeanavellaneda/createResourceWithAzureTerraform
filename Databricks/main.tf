resource "azurerm_databricks_workspace" "databricks" {
  name                = var.base_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "standard"
}

# Create Databricks Cluster
/*resource "databricks_cluster" "cluster" {
  cluster_name            = "etl-cluster"
  spark_version           = "13.3.x-scala2.12"  # Use a valid Spark version
  node_type_id            = "Standard_D8s_v3"   # Select an appropriate node type
  autotermination_minutes = 15                  # Auto-terminate after 15 minutes of inactivity
  num_workers             = 2                   # Number of worker nodes
}*/

# Crear el cluster de Databricks
/*resource "databricks_cluster" "etl_cluster" {
  cluster_name            = "covid-etl-cluster"
  spark_version           = "3.5.x-scala2.12" # Define la versión de Spark
  node_type_id            = "Standard_D8s_v3"
  autoscale {
    min_workers = 1
    max_workers = 3
  }
  autotermination_minutes = 20  # Apaga el cluster después de 20 minutos de inactividad
}*/
