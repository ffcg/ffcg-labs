@description('Prefix. Initials of the resource owner')
param prefix string = ''

@description('Source Storage account name')
param srcStorageAccountName string

@description('Source blob container name')
param srcStorageContainerName string

@description('Destination Azure SQL Database name')
param destSqlDatabaseName string

@description('Destination Azure SQL Database connection string')
param destSqlDatabaseConnectionString string

var rg = resourceGroup()

module adfPipeline './modules/data-factory/main.bicep' = {
  name: '${prefix}_main_adf_deploy'
  params: {
    location: rg.location
    prefix: prefix
    srcStorageAccountName: srcStorageAccountName
    srcStorageContainerName: srcStorageContainerName
    destSqlDatabaseName: destSqlDatabaseName
    destSqlDatabaseConnectionString: destSqlDatabaseConnectionString
  }
}
