@description('Prefix. Initials of the resource owner')
param prefix string

@description('Resource group location')
param location string = resourceGroup().location

@description('Source Storage account name')
param srcStorageAccountName string

@description('Source blob container name')
param srcStorageContainerName string

@description('Destination Azure SQL Database name')
param destSqlDatabaseName string

@description('Destination Azure SQL Database connection string')
param destSqlDatabaseConnectionString string

var folderName = 'TaxiRides'

module adfInstance 'instance.bicep' = {
  name: '${prefix}_adf_instance_deploy'
  params: {
    location: location
    prefix: prefix
  }
}

module adfLinkedServices 'linked_services.bicep' = {
  dependsOn: [
    adfInstance
  ]
  name: '${prefix}_adf_ls_deploy'
  params: {
    dataFactoryName: adfInstance.outputs.dataFactoryName
    destSqlDatabaseConnectionString: destSqlDatabaseConnectionString
    destSqlDatabaseName: destSqlDatabaseName
    srcStorageAccountName: srcStorageAccountName
  }
}

module adfDatasets 'datasets.bicep' = {
  dependsOn: [
    adfLinkedServices
  ]
  name: '${prefix}_adf_ds_deploy'
  params: {
    dataFactoryName: adfInstance.outputs.dataFactoryName
    srcContainerName: srcStorageContainerName
    linkedServiceNames: adfLinkedServices.outputs.linkedServices
    folderName: folderName
  }
}

module adfDataFlows 'data_flows.bicep' = {
  dependsOn: [
    adfDatasets
  ]
  name: '${prefix}_adf_flow_deploy'
  params: {
    dataFactoryName: adfInstance.outputs.dataFactoryName
    folderName: folderName
    datasetNames: adfDatasets.outputs.datasetNames
  }
}

module adfPipelines 'pipelines.bicep' = {
  dependsOn: [
    adfDataFlows
  ]
  name: '${prefix}_adf_ppln_deploy'
  params: {
    dataFactoryName: adfInstance.outputs.dataFactoryName
    folderName: folderName
    dataFlowName: adfDataFlows.outputs.dataFlowName
  }
}

module adfTriggers 'triggers.bicep' = {
  dependsOn: [
    adfPipelines
  ]
  name: '${prefix}_adf_trg_deploy'
  params: {
    dataFactoryName: adfInstance.outputs.dataFactoryName
    pipelineName: adfPipelines.outputs.pipelineName
    srcStorageAccountName: srcStorageAccountName
    srcContainerName: srcStorageContainerName
  }
}

output dataFactoryName string = adfInstance.outputs.dataFactoryName
output triggerName string = adfTriggers.outputs.triggerName
