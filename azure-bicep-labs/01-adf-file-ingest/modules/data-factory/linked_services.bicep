@description('ADF instance name')
param dataFactoryName string

@description('Source Storage Account name')
param srcStorageAccountName string

@description('Destination SQL Database name')
param destSqlDatabaseName string

@description('Destination SQL Database connection string')
param destSqlDatabaseConnectionString string

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource srcStorageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: srcStorageAccountName
}

resource destSqlDatabase 'Microsoft.Sql/servers/databases@2022-02-01-preview' existing = {
  name: destSqlDatabaseName
}

var srcStorageAccountLinkedServiceName = 'ls_${srcStorageAccountName}'
var destSqlDatabaseLinkedServiceName = 'ls_${destSqlDatabase.name}'

resource lsSrcStorageAccount 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  parent: dataFactory
  name: srcStorageAccountLinkedServiceName
  properties: {
    type: 'AzureBlobStorage'
    typeProperties: {
      connectionString: 'DefaultEndpointsProtocol=https;AccountName=${srcStorageAccountName};AccountKey=${listKeys(srcStorageAccount.id, srcStorageAccount.apiVersion).keys[0].value}'
    }
  }
}

resource lsDestSqlDatabase 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  parent: dataFactory
  name: destSqlDatabaseLinkedServiceName
  properties: {
    type: 'AzureSqlDatabase'
    typeProperties: {
      connectionString: destSqlDatabaseConnectionString
    }
  }
}

output linkedServices object = {
  sourceStorageAccount: srcStorageAccountLinkedServiceName
  destinationSqlDatabase: destSqlDatabaseLinkedServiceName
}
