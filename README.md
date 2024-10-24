# Crear recursos Azure para ETL mediante terraform

## Prerequisitos : 
- Descargar y configurar el ejecutable de terraform : https://developer.hashicorp.com/terraform/install
- Instalar cliente azure : https://learn.microsoft.com/es-es/cli/azure/install-azure-cli

## Descargar el proyecto :
```shell
git clone https://github.com/jeanavellaneda/createResourceWithAzureTerraform.git
```

## Auntenticación :
### Abrir una terminal
- az login
- az account set --subscription "SUBSCRIPTION-ID"
- az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/"SUBSCRIPTION-ID"

## Ejecuar terraform
-----------------

- terraform init --> Descarga los providers, crear la carpeta .terraform y .terraform.lock.hcl
- terraform validate --> Valida la configuración de Terraform
- terraform plan --> Genera un plan de ejecución
- terraform apply --> Aplica los cambios definidos en la configuración de Terraform
- terrform destroy --> Elimina todos los recursos gestionados por Terraform en la configuración actual.