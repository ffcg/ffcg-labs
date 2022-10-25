@description('Prefix. Initials of the resource owner')
param prefix string = ''

@description('Admin user name for Azure SQL Database')
param adminUsername string

@secure()
@description('Admin user password for Azure SQL Database')
param adminPassword string

@description('Local IP address for Sql Database firewall')
param localIpAddress string

var rg = resourceGroup()

module sa './modules/storage-account/main.bicep' = {
  name: '${prefix}_storage_deploy'
  params: {
    location: rg.location
    prefix: prefix
  }
}

module db './modules/azure-sql-db/main.bicep' = {
  dependsOn: [
    //mi
    sa
  ]
  name: '${prefix}_sql_deploy'
  params: {
    location: rg.location
    prefix: prefix
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
    localIpAddress: localIpAddress
  }
}

output storageAccountName string = sa.outputs.storageAccountName
output containerName string = sa.outputs.containerName
output dacpacContainerSASToken string = sa.outputs.backupContainerUploadSAS
output sqlServerName string = db.outputs.sqlServerName
output sqlDatabaseName string = db.outputs.sqlDatabaseName
output sqlDatabaseConnectionString string = db.outputs.connectionString
