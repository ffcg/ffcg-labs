@description('Prefix. Initials of the resource owner')
param prefix string

@description('ADF instance name')
param dataFactoryName string = '${prefix}-adf-01'

@description('Resource group location')
param location string = resourceGroup().location

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  tags: {
    Purpose: 'techevolution'
  }
  identity: {
    type: 'SystemAssigned'
  }
}

output dataFactoryName string = dataFactory.name
