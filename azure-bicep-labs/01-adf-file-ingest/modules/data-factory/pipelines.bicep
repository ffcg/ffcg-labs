@description('ADF instance name')
param dataFactoryName string

@description('ADF folder name')
param folderName string = 'Main'

@description('ADF data flow name')
param dataFlowName string

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource flow 'Microsoft.DataFactory/factories/dataflows@2018-06-01' existing = {
  name: dataFlowName
}

resource pplnTaxiRides 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: 'ppln_ingest_taxi_rides'
  parent: dataFactory
  properties: {
    activities: [
      {
        name: 'IngestTaxiRides'
        type: 'ExecuteDataFlow'
        typeProperties: {
          compute: {
            // marked as Small in ADF UI
            computeType: 'General'
            coreCount: 8
          }
          dataFlow: {
            referenceName: flow.name
            type: 'DataFlowReference'
            datasetParameters: {
              srcTaxiRidesBlob: {
                  fileName: {
                      value: '@pipeline().parameters.fileName'
                      type: 'Expression'
                  }
              }
            }
          }
          traceLevel: 'fine'
        }
      }
    ]
    folder: {
      name: folderName
    }
    parameters: {
      fileName: {
        type: 'string'
      }
    }
  }
}

output pipelineName string = pplnTaxiRides.name
