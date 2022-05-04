# Store file metadata function

This Azure function triggers on HTTP GET/POST and retrieves metadata from all files stored in the Cosmos DB

How to create functions and setting up bindings are described in the [documentation](https://docs.microsoft.com/en-us/azure/azure-functions/). This lab is based upon the [VSCode C# quickstart](https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-csharp?tabs=in-process&pivots=programming-runtime-functions-v3) but feel free to follow any of the other guides if you prefer another IDE or language.

This function uses [HTTP Trigger binding](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-http-webhook-trigger?tabs=csharp) and [Cosmos DB Input binding](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-cosmosdb-v2-input?tabs=csharp).

To have some data in the database, you should have setup the infrastructure for [StoreMetadataFunction](../store-metadata-function) and ran it once atleast.

## Test existing example

`curl https://kpa-list-metadata.azurewebsites.net/api/ListMetadataFunction`


## Setup infrastructure

Several of the resources created in [StoreMetadataFunction](../store-metadata-function) are used but we need one more Function App since the deploy from VSCode overwrites all existing functions. Another option would be to have both function in the same project.

1. [Create a Function App in the portal](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-function-app-portal#create-a-function-app). Select Serverless-kurs resource group, start the name with your initials, Publish Code, Runtime stack .NET, Version 3.1, Region West Europe. Change to Hosting, select the storage account created above and Consumption plan

## Setup

1. [Prepare VSCode for Azure function development](https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-csharp?tabs=in-process&pivots=programming-runtime-functions-v3#configure-your-environment) if you have not done it before
1. Clone the repo if you have not done before
1. Open project in VSCode, i.e. this folder
1. Create a local.settings.json file based on template.settings.json and set DatabaseConnectionString to the connections string of the CosmosDB created above. Also set AzureWebJobsStorage to that connection string of the storage account, both created in [StoreMetadataFunction](../store-metadata-function).
1. Deploy the function using the built in support of VSCode, see this [article](https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-vs-code-csharp?tabs=in-process&pivots=programming-runtime-functions-v3#sign-in-to-azure).
1. Use the Azure navigator in VSCode and find Forefront BR Lab/Demo and your app function under it. Right click the Application Settings and select Upload local settings. This will set settings in the portal with the same values as the one in your local file.
1. Open logs in the function monitor, under Functions in the Function App and then click 
StoreFileMetadataFunction. Then Monitor and the Logs tab.
1. Use curl to list metadata about all files: curl https://{your function app}.azurewebsites.net/api/ListMetadataFunction
1. Congratulation you have taken another successful step in your serverless journey!
