# Store file metadata function

This Azure function triggers on files uploaded to a Blob container in a storage account and save some metadata about the file a Cosmos DB

How to create functions and setting up bindings are described in the [documentation](https://docs.microsoft.com/en-us/azure/azure-functions/).

## Setup

1. Open project in VSCode for instance
1. Create a Storage Account and a blob container inside it called files
1. Create a CosmosDB with a database called ServerlessLab and collection inside it called FileMetaData
1. Create a local.settings.json file based on template.settings.json and set CosmosDBConnection to the connections string of the CosmosDB create above. And StorageConnection to the connections string of the Storage Account(is under Access Keys)
1. Deploy the function using the built in support of VSCode
1. Generate a SAS token for the blob container called files
1. Find a test file and upload it with curl(replace STORAGE_ACCOUNT with the name of your storage account and SAS_TOKEN with the token you just created ): curl -X PUT -T ~/mandril_color.tif -H "x-ms-date: $(date -u)" -H "x-ms-blob-type: BlockBlob" "https://{STORAGE_ACCOUNT}.blob.core.windows.net/files/mandril.tif?{SAS_TOKEN}"

