@description('Prefix. Initials of the resource owner')
param prefix string

@description('The name of the SQL logical server.')
param serverName string = '${prefix}-sql-01'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The name of the SQL Database.')
param sqlDBName string = 'lab_db'

@description('The administrator username of the SQL logical server.')
param administratorLogin string = 'db_admin'

@description('The administrator password of the SQL logical server.')
param administratorLoginPassword string

@description('Local IP address for Sql Database firewall')
param localIpAddress string

resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: serverName
  location: location
  tags: {
    Purpose: 'techevolution'
  }
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

resource sqlServerFirewallEnableAzure 'Microsoft.Sql/servers/firewallRules@2022-02-01-preview' = {
  name: 'enable_azure_services'
  parent: sqlServer
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

resource sqlServerFirewallEnableLocalIp 'Microsoft.Sql/servers/firewallRules@2022-02-01-preview' = {
  name: 'enable_local'
  parent: sqlServer
  properties: {
    endIpAddress: localIpAddress
    startIpAddress: localIpAddress
  }
}

resource sqlDb 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  parent: sqlServer
  name: sqlDBName
  location: location
  tags: {
    Purpose: 'techevolution'
  }
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
}

output sqlServerName string = sqlServer.name
output sqlDatabaseName string = sqlDb.name
output connectionString string = 'Data Source=tcp:${sqlServer.name}${environment().suffixes.sqlServerHostname},1433;Initial Catalog=${sqlDb.name};Persist Security Info=False;User ID=${sqlServer.properties.administratorLogin}@${sqlServer.name};Password=${administratorLoginPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
