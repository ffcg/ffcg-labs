@description('ADF instance name')
param dataFactoryName string

@description('ADF folder name')
param folderName string = 'Main'

@description('ADF linked services object')
param datasetNames object

resource dsInput 'Microsoft.DataFactory/factories/datasets@2018-06-01' existing = {
  name: datasetNames.input
}

resource dsOutput 'Microsoft.DataFactory/factories/datasets@2018-06-01' existing = {
  name: datasetNames.output
}

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource flowTaxiTides 'Microsoft.DataFactory/factories/dataflows@2018-06-01' = {
  name: 'flow_taxi_rides'
  parent: dataFactory
  properties: {
    folder: {
      name: folderName
    }
    type: 'MappingDataFlow'
    typeProperties: {
      sources: [
        {
          dataset: {
            parameters: {
              fileName: {
                value: '@pipeline().parameters.fileName'
              }
            }
            referenceName: dsInput.name
            type: 'DatasetReference'
          }
          // description: 'string'
          // flowlet: {
          //   datasetParameters: any()
          //   parameters: {}
          //   referenceName: 'string'
          //   type: 'DataFlowReference'
          // }
          // linkedService: {
          //   parameters: {}
          //   referenceName: 'string'
          //   type: 'LinkedServiceReference'
          // }
          name: 'srcTaxiRidesBlob'
          // schemaLinkedService: {
          //   parameters: {}
          //   referenceName: 'string'
          //   type: 'LinkedServiceReference'
          // }
        }
      ]
      sinks: [
        {
          dataset: {
            referenceName: dsOutput.name
            type: 'DatasetReference'
          }
          // description: 'string'
          // flowlet: {
          //   datasetParameters: any()
          //   parameters: {}
          //   referenceName: 'string'
          //   type: 'DataFlowReference'
          // }
          // linkedService: {
          //   parameters: {}
          //   referenceName: 'string'
          //   type: 'LinkedServiceReference'
          // }
          name: 'destSqlTaxiRides'
          // rejectedDataLinkedService: {
          //   parameters: {}
          //   referenceName: 'string'
          //   type: 'LinkedServiceReference'
          // }
          // schemaLinkedService: {
          //   parameters: {}
          //   referenceName: 'string'
          //   type: 'LinkedServiceReference'
          // }
        }
      ]
      transformations: [
        {
          description: 'Change timestamp label UTC to Z'
          name: 'harmonizeTimestamps'
        }
      ]
      scriptLines: [
        'source(output('
        '          unique_key as string,'
        '          taxi_id as string,'
        '          trip_start_timestamp as string,'
        '          trip_end_timestamp as string,'
        '          trip_seconds as integer,'
        '          trip_miles as double,'
        '          fare as double,'
        '          tips as double,'
        '          tolls as double,'
        '          extras as double,'
        '          trip_total as double,'
        '          payment_type as string,'
        '          company as string,'
        '          pickup_latitude as string,'
        '          pickup_longitude as string'
        '     ),'
        '     allowSchemaDrift: true,'
        '     ignoreNoFilesFound: false) ~> srcTaxiRidesBlob'
        'srcTaxiRidesBlob derive(trip_start_timestamp = toTimestamp(replace(trip_start_timestamp, \' UTC\', \'Z\')),'
        '          trip_end_timestamp = toTimestamp(replace(trip_end_timestamp, \' UTC\', \'Z\'))) ~> harmonizeTimestamps'
        'harmonizeTimestamps sink(allowSchemaDrift: true,'
        '     validateSchema: false,'
        '     input('
        '          unique_key as string,'
        '          taxi_id as string,'
        '          trip_start_timestamp as timestamp,'
        '          trip_end_timestamp as timestamp,'
        '          trip_seconds as integer,'
        '          trip_miles as double,'
        '          fare as decimal(18,0),'
        '          tips as decimal(18,0),'
        '          tolls as decimal(18,0),'
        '          extras as decimal(18,0),'
        '          trip_total as decimal(18,0),'
        '          payment_type as string,'
        '          company as string,'
        '          pickup_latitude as string,'
        '          pickup_longitude as string,'
        '          record_created_at as timestamp'
        '     ),'
        '     deletable:false,'
        '     insertable:true,'
        '     updateable:false,'
        '     upsertable:false,'
        '     format: \'table\','
        '     skipDuplicateMapInputs: true,'
        '     skipDuplicateMapOutputs: true,'
        '     errorHandlingOption: \'stopOnFirstError\','
        '     mapColumn('
        '       unique_key,'
        '       taxi_id,'
        '       trip_start_timestamp,'
        '       trip_end_timestamp,'
        '       trip_seconds,'
        '       trip_miles,'
        '       fare,'
        '       tips,'
        '       tolls,'
        '       extras,'
        '       trip_total,'
        '       payment_type,'
        '       company,'
        '       pickup_latitude,'
        '       pickup_longitude'
        ')) ~> destSqlTaxiRides'
      ]
    }
  }
}

output dataFlowName string = flowTaxiTides.name
