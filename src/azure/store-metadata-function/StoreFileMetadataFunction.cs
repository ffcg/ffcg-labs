using System;
using System.IO;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace Forefront.ServerlessLab.Function
{
    public static class StoreFileMetadataFunction
    {
        [FunctionName("StoreFileMetadataFunction")]
        public static void Run(
            [BlobTrigger("files/{name}", Connection = "StorageConnection")]Stream blob, string name,
            [CosmosDB(
                databaseName: "ServerlessLab",
                collectionName: "FileMetaData",
                ConnectionStringSetting = "CosmosDBConnection")]out dynamic file,
            ILogger log)
        {
            log.LogInformation($"C# Blob trigger function\n Name:{name} \n Size: {blob.Length} Bytes");
            file = new { Filename = name, Size = blob.Length, id = Guid.NewGuid() };
        }
    }
}
