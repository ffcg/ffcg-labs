#!/bin/bash

set -x
SUBSCRIPTION_NAME="Forefront Labs"
REGION_NAME="Norway East" # Sweden Central does not have Data Factory yet

# Replace with the relevant group name
RESOURCE_GROUP_NAME="ffla-tech-evo-oct-2022"

# Replace with your initials
PREFIX="jec"

DB_USERNAME="db_admin"
DB_PASSWORD="pAssw0rd123" # Don't hardcode passwords in real-life projects :)

LOCAL_IP_ADDRESS=$(curl -s ifconfig.me)

##############
az login

az account set --name "${SUBSCRIPTION_NAME}"

# The script requires some extensions like datafactory
az config set extension.use_dynamic_install=yes_without_prompt

echo "Deploying Storage layer..."

storage_deploy_output=$(az deployment group create \
  --name "${PREFIX}_deploy_layer_storage" \
  --resource-group "${RESOURCE_GROUP_NAME}" \
  --template-file "./1_deploy_storage.bicep" \
  --parameters prefix="${PREFIX}" adminUsername="${DB_USERNAME}" adminPassword="${DB_PASSWORD}" localIpAddress="${LOCAL_IP_ADDRESS}")

# echo "${storage_deploy_output}" # To see the outputs

sa_name=$(echo "${storage_deploy_output}" | jq -r '.properties.outputs.storageAccountName.value')

blob_container_name=$(echo "${storage_deploy_output}" | jq -r '.properties.outputs.containerName.value')

sql_db_name=$(echo "${storage_deploy_output}" | jq -r '.properties.outputs.sqlDatabaseName.value')

sql_db_connection_string=$(echo "${storage_deploy_output}" | jq -r '.properties.outputs.sqlDatabaseConnectionString.value')

# Publish a dacpac file
# Note: az sql db import won't work with dacpac cause it will throw an error:
# "Cannot create a BACPAC from a file that does not contain exported data."
sqlPackageCommand="SqlPackage.exe" && [[ $(uname) == "Darwin" ]] && sqlPackageCommand="sqlpackage"
${sqlPackageCommand} \
  /Action:Publish \
  /SourceFile:"./projects/lab_db/bin/Debug/lab_db.dacpac" \
  /TargetConnectionString:"${sql_db_connection_string}"

echo "Storage layer is deployed"
echo "Deploying Process layer..."

process_deploy_output=$(az deployment group create \
  --name "${PREFIX}_deploy_layer_process" \
  --resource-group "${RESOURCE_GROUP_NAME}" \
  --template-file "./2_deploy_process.bicep" \
  --parameters prefix="${PREFIX}" srcStorageAccountName="${sa_name}" srcStorageContainerName="${blob_container_name}" destSqlDatabaseName="${sql_db_name}" destSqlDatabaseConnectionString="${sql_db_connection_string}")

# echo "${process_deploy_output}" # To see the outputs

adf_name=$(echo "${process_deploy_output}" | jq -r '.properties.outputs.dataFactoryName.value')
adf_trigger_name=$(echo "${process_deploy_output}" | jq -r '.properties.outputs.dataFactoryTriggerName.value')

echo "Process layer is deployed"
echo "Starting Azure Data Factory ${adf_name} trigger ${adf_trigger_name}..."

az datafactory trigger start \
  --factory-name "${adf_name}" \
  --resource-group "${RESOURCE_GROUP_NAME}" \
  --name "${adf_trigger_name}"

echo "Done"