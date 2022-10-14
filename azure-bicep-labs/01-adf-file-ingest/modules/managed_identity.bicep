@description('Prefix. Initials of the resource owner')
param prefix string

@description('Location for all resources.')
param location string = resourceGroup().location

resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: '${prefix}-usermi'
  tags: {
    Purpose: 'techevolution'
  }
  location: location
}

output user_mi_name string = uami.name
