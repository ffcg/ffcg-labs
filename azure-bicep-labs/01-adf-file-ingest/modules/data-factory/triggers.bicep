@description('ADF instance name')
param dataFactoryName string

@description('ADF pipeline name')
param pipelineName string

@description('Source Storage account name')
param srcStorageAccountName string

@description('Source storage container name')
param srcContainerName string

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource sa 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: srcStorageAccountName
}

resource blobUpdateTrigger 'Microsoft.DataFactory/factories/triggers@2018-06-01' = {
  name: 'trg_${pipelineName}'
  parent: dataFactory
  properties: {
    type: 'BlobEventsTrigger'
    pipelines: [
      {
        parameters: {}
        pipelineReference: {
          referenceName: pipelineName
          type: 'PipelineReference'
        }
      }
    ]
    typeProperties: {
      blobPathBeginsWith: '/${srcContainerName}/blobs/'
      blobPathEndsWith: '.csv'
      events: [
        'Microsoft.Storage.BlobCreated'
      ]
      ignoreEmptyBlobs: true
      scope: sa.id
    }
  }
}
