@description('ADF instance name')
param dataFactoryName string

@description('ADF linked services object')
param linkedServiceNames object

@description('ADF folder name')
param folderName string = 'Main'

@description('Source storage container name')
param srcContainerName string

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource lsSrcStorageAccount 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' existing = {
  name: linkedServiceNames.sourceStorageAccount
}

resource lsDestSqlDatabase 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' existing = {
  name: linkedServiceNames.destinationSqlDatabase
}

resource srcContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' existing = {
  name: srcContainerName
}

resource dsSaInputTaxiRides 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: 'ds_blob_input_taxi_rides'
  parent: dataFactory
  properties: {
    folder: {
      name: folderName
    }
    linkedServiceName: {
      parameters: {}
      referenceName: lsSrcStorageAccount.name
      type: 'LinkedServiceReference'
    }
    parameters: {
      fileName: {
        type: 'string'
      }
    }
    schema: [
      { name: 'unique_key', type: 'string' }
      { name: 'taxi_id', type: 'string' }
      { name: 'trip_start_timestamp', type: 'string' }
      { name: 'trip_end_timestamp', type: 'string' }
      { name: 'trip_seconds', type: 'string' }
      { name: 'trip_miles', type: 'string' }
      { name: 'fare', type: 'string' }
      { name: 'tips', type: 'string' }
      { name: 'tolls', type: 'string' }
      { name: 'extras', type: 'string' }
      { name: 'trip_total', type: 'string' }
      { name: 'payment_type', type: 'string' }
      { name: 'company', type: 'string' }
      { name: 'pickup_latitude', type: 'string' }
      { name: 'pickup_longitude', type: 'string' }
    ]
    type: 'DelimitedText'
    typeProperties: {
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '\''
      location: {
        type: 'AzureBlobStorageLocation'
        container: srcContainer.name
        fileName: {
          value: '@dataset().fileName'
          type: 'Expression'
        }
      }
    }
  }
}

resource dsSqlTaxiRides 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: 'ds_asql_taxi_rides'
  parent: dataFactory
  properties: {
    folder: {
      name: folderName
    }
    linkedServiceName: {
      parameters: {}
      referenceName: lsDestSqlDatabase.name
      type: 'LinkedServiceReference'
    }
    type: 'AzureSqlTable'
    typeProperties: {
      schema: 'dbo'
      table: 'taxi_rides'
    }
    parameters: {}
    // https://learn.microsoft.com/en-us/azure/data-factory/connector-sql-server?tabs=data-factory#data-type-mapping-for-sql-server
    schema: [
      { name: 'unique_key', type: 'nvarchar' }
      { name: 'taxi_id', type: 'nvarchar' }
      { name: 'trip_start_timestamp', type: 'datetime2', scale: 7 }
      { name: 'trip_end_timestamp', type: 'datetime2', scale: 7 }
      { name: 'trip_seconds', type: 'int', precision: 10}
      { name: 'trip_miles', type: 'float', precision: 15 }
      { name: 'fare', type: 'decimal', precision: 18, scale: 0 }
      { name: 'tips', type: 'decimal', precision: 18, scale: 0 }
      { name: 'tolls', type: 'decimal', precision: 18, scale: 0 }
      { name: 'extras', type: 'decimal', precision: 18, scale: 0 }
      { name: 'trip_total', type: 'decimal', precision: 18, scale: 0 }
      { name: 'payment_type', type: 'nvarchar' }
      { name: 'company', type: 'nvarchar' }
      { name: 'pickup_latitude', type: 'nvarchar' }
      { name: 'pickup_longitude', type: 'nvarchar' }
      { name: 'record_created_at', type: 'datetime', precision: 23, scale: 3 }
    ]
  }
}

output datasetNames object = {
  input: dsSaInputTaxiRides.name
  output: dsSqlTaxiRides.name
}
