@description('ADF instance name')
param dataFactoryName string

@description('ADF folder name')
param folderName string = 'Main'

@description('ADF linked services object')
param datasetNames object

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource dsInput 'Microsoft.DataFactory/factories/datasets@2018-06-01' existing = {
  name: datasetNames.input
}

resource dsOutput 'Microsoft.DataFactory/factories/datasets@2018-06-01' existing = {
  name: datasetNames.output
}

resource pplnTaxiRides 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: 'ppln_ingest_taxi_rides'
  parent: dataFactory
  properties: {
    activities: [
      {
        name: 'IngestTaxiRides'
        type: 'Copy'
        inputs: [
          {
            parameters: {}
            referenceName: dsInput.name
            type: 'DatasetReference'
          }
        ]
        outputs: [
          {
            parameters: {}
            referenceName: dsOutput.name
            type: 'DatasetReference'
          }
        ]
        typeProperties: {
          source: {
            type: 'DelimitedTextSource'
            formatSettings: {
              type: 'DelimitedTextReadSettings'
              skipLineCount: 1
            }
            storeSettings: {
              type: 'AzureBlobStorageReadSettings'
              recursive: true
            }
          }
          sink: {
            type: 'AzureSqlSink'
            writeBehavior: 'insert'
          }
        }
      }
    ]
    description: 'Demo pipeline'
    folder: {
      name: folderName
    }
    parameters: {}
    variables: {}
  }
}

output pipelineName string = pplnTaxiRides.name
