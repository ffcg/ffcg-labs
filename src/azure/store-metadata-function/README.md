# Store file metadata function

This Azure function triggers on files uploaded to a Blob container in a storage account and save some metadata about the file a Cosmos DB

How to create functions and setting up bindings are described in the [documentation](https://docs.microsoft.com/en-us/azure/azure-functions/). This lab is based upon the [VSCode C# quickstart](https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-csharp?tabs=in-process&pivots=programming-runtime-functions-v3) but feel free to follow any of the other guides if you prefer another IDE or language.

This function uses [Blob Storage Trigger binding](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-storage-blob-trigger?tabs=csharp) and [Cosmos DB Output binding](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-cosmosdb-v2-output?tabs=csharp).

## Test existing example

`curl -X PUT -T example_images/mandril_color.tif -H "x-ms-date: $(date -u)" -H "x-ms-blob-type: BlockBlob" "https://kpastorage.blob.core.windows.net/files/mandril.tif?sp=rw&st=2021-10-25T19:29:23Z&se=2021-11-26T04:29:23Z&sv=2020-08-04&sr=c&sig=N3qtYLkhKjCelgq7IMIzHHwRLcsGo1dk4IHb7E9qqVw%3D"`


## Setup infrastructure

At the moment there exists not Terraform to setup this infrastructure, use these steps instead

1. [Create a storage account in the portal](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-portal#create-a-storage-account-1) or use the terraform-script to create one. If you use the portal, select Serverless-kurs resource group, start the name with your initials, West Europe region and Standard performance
1. [Create a container](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-portal#create-a-container) inside the storage account, name it files and set Public access level to Blob if you want to present uploaded files on a webpage or similar
1. [Create a Cosmos account](https://docs.microsoft.com/en-us/azure/cosmos-db/sql/create-cosmosdb-resources-portal#create-an-azure-cosmos-db-account). Select the Core (SQL) API, select Serverless-kurs resource group, start the name with your initials, West Europe region and Serverless
1. [Add a database inside CosmosDB](https://docs.microsoft.com/en-us/azure/cosmos-db/sql/create-cosmosdb-resources-portal#add-a-database-and-a-container) (via Data Explorer) called ServerlessLab and a container inside it called FileMetaData(select Use existing ServerlessLab, Container id FileMetaData, Partition Key /FileMetaData)
1. [Create a Function App in the portal](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-function-app-portal#create-a-function-app). Select Serverless-kurs resource group, start the name with your initials, Publish Code, Runtime stack .NET, Version 3.1, Region West Europe. Change to Hosting, select the storage account created above and Consumption plan

## Setup

1. [Prepare VSCode for Azure function development](https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-csharp?tabs=in-process&pivots=programming-runtime-functions-v3#configure-your-environment)
1. Clone the repo
1. Open project in VSCode, i.e. this folder
1. Create a local.settings.json file based on template.settings.json and set DatabaseConnectionString to the connections string of the CosmosDB created above. And FileStorageConnectionsString to the connections string of the Storage Account(is under Access Keys), also set AzureWebJobsStorage to that connection string.
1. Deploy the function using the built in support of VSCode, see this [article](https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-csharp?tabs=in-process&pivots=programming-runtime-functions-v3#sign-in-to-azure).
1. Use the Azure navigator in VSCode and find Forefront BR Lab/Demo and your app function under it. Right click the Application Settings and select Upload local settings. This will set settings in the portal with the same values as the one in your local file.
1. Generate a SAS token for the blob container called files, see this [article](https://docs.microsoft.com/en-us/azure/cognitive-services/translator/document-translation/create-sas-tokens?tabs=Containers#create-sas-tokens-for-blobs-in-the-azure-portal).
1. Open logs in the function monitor, under Functions in the Function App and then click 
StoreFileMetadataFunction. Then Monitor and the Logs tab.
1. Test to upload the test file in example_images and upload it with curl(replace STORAGE_ACCOUNT with the name of your storage account and SAS_TOKEN with the token you just created ): `curl -X PUT -T example_images/mandril_color.tif -H "x-ms-date: $(date -u)" -H "x-ms-blob-type: BlockBlob" "https://{STORAGE_ACCOUNT}.blob.core.windows.net/files/mandril.tif?{SAS_TOKEN}"`
1. Look inside the Cosmos DB to see what metadata was posted.
1. Congratulation you have taken another successful step in your serverless journey!
