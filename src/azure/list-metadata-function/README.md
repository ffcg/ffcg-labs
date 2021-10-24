# Store file metadata function

This Azure function triggers on HTTP GET/POST and retrieves metadata from all files stored in the Cosmos DB

How to create functions and setting up bindings are described in the [documentation](https://docs.microsoft.com/en-us/azure/azure-functions/).

## Setup

1. Open project in VSCode for instance
1. Create a local.settings.json file based on template.settings.json and set CosmosDBConnection to the connections string of the CosmosDB. The same CosmosDb created in store-metadata-function
1. Deploy the function using the built in support of VSCode
1. Use curl to list metadata about all files: curl https://{your app service}.azurewebsites.net/api/ListMetadataFunction 
