#!/bin/bash

SUBSCRIPTION_NAME="Forefront Labs"
REGION_NAME="Norway East" # Sweden Central does not have Data Factory yet

# Replace with the relevant group name
RESOURCE_GROUP_NAME="ffla-tech-evo-oct-2022"

# Replace with your initials
PREFIX="vga"

DB_USERNAME="db_admin"
DB_PASSWORD="pAssw0rd123" # Don't hardcode passwords in real-life projects :)

# Replace with your external IP address
# Needed to publish db projects to sql db
LOCAL_IP_ADDRESS="188.150.247.177"

##############
az login

az account set --name "$SUBSCRIPTION_NAME"

deploy_output=$(az deployment group create \
  --name "${PREFIX}_deploy_layer_storage" \
  --resource-group $RESOURCE_GROUP_NAME \
  --template-file "./1_deploy_storage.bicep" \
  --parameters prefix=$PREFIX adminUsername=$DB_USERNAME adminPassword="$DB_PASSWORD" localIpAddress="$LOCAL_IP_ADDRESS")

# echo "${deploy_output}" # To see the outputs

sa_name=$(echo $deploy_output | jq -r '.properties.outputs.storageAccountName.value')

blob_container_name=$(echo $deploy_output | jq -r '.properties.outputs.containerName.value')

# dacpac_container_sas_token=$(echo $deploy_output | jq -r '.properties.outputs.dacpacContainerSASToken.value')

# dacpac_blob_uri="https://${sa_name}.blob.core.windows.net/backup/lab_db.dacpac" 

# sql_server_name=$(echo $deploy_output | jq -r '.properties.outputs.sqlServerName.value')
sql_db_name=$(echo $deploy_output | jq -r '.properties.outputs.sqlDatabaseName.value')

sql_db_connection_string=$(echo $deploy_output | jq -r '.properties.outputs.sqlDatabaseConnectionString.value')

# Publish a dacpac file
# Note: az sql db import won't work with dacpac cause it will throw an error:
# "Cannot create a BACPAC from a file that does not contain exported data."
SqlPackage.exe \
  /Action:Publish \
  /SourceFile:"./projects/lab_db/bin/Debug/lab_db.dacpac" \
  /TargetConnectionString:"${sql_db_connection_string}"

az deployment group create \
  --name "${PREFIX}_deploy_layer_process" \
  --resource-group $RESOURCE_GROUP_NAME \
  --template-file "./2_deploy_process.bicep" \
  --parameters prefix=$PREFIX srcStorageAccountName=$sa_name srcStorageContainerName=$blob_container_name destSqlDatabaseName=$sql_db_name destSqlDatabaseConnectionString="${sql_db_connection_string}"