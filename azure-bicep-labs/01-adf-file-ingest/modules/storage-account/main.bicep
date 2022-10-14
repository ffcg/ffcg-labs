@description('Prefix. Initials of the resource owner')
param prefix string

@description('Storage Account type')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param storageAccountType string = 'Standard_LRS'

@description('Location for the storage account.')
param location string = resourceGroup().location

@description('User-assigned Managed Identity name to run deployment scripts')
param uamiName string

@description('Anchor time for SAS tokens. Default is set to utcNow')
param anchorTime string = utcNow('yyyy-MM-ddTHH:mm:ssZ')

var storageAccountName = '${prefix}sastage'
var containerName = 'ingest'

resource sa 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  tags: {
    Purpose: 'techevolution'
  }
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {}
}

resource stagingContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: '${storageAccountName}/default/${containerName}'
  dependsOn: [
    sa
  ]
}

resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: uamiName
}

output storageAccountName string = storageAccountName
output containerName string = containerName

// signedPermission order
// (r)ead (a)dd (c)reate (w)rite (d)elete (l)ist (i)mmutable storage
output backupContainerUploadSAS string = listServiceSAS(sa.name,'2021-09-01', {
  canonicalizedResource: '/blob/${sa.name}/backup'
  signedResource: 'c'
  signedProtocol: 'https'
  signedPermission: 'rcwl'
  signedStart: anchorTime
  signedExpiry: dateTimeAdd(anchorTime, 'PT1H')
  keyToSign: 'key1'
}).serviceSasToken
