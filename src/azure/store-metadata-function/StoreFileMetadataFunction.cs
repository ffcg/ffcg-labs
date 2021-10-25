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
            [BlobTrigger("files/{name}", Connection = "FileStorageConnectionsString")]Stream blob, string name,
            [CosmosDB(
                databaseName: "ServerlessLab",
                collectionName: "FileMetaData",
                ConnectionStringSetting = "DatabaseConnectionString")]out dynamic file,
            ILogger log)
        {
            log.LogInformation($"C# Blob trigger function - Name:{name} - Size: {blob.Length} Bytes");
            file = new { Filename = name, Size = blob.Length, id = Guid.NewGuid() };
        }
    }
}
