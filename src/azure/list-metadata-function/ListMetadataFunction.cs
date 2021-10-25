using System;
using System.IO;
using System.Threading.Tasks;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace Forefront.ServerlessLab.Function
{
    public static class ListMetadataFunction
    {
        [FunctionName("ListMetadataFunction")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            [CosmosDB(
                databaseName: "ServerlessLab",
                collectionName: "FileMetaData",
                ConnectionStringSetting = "DatabaseConnectionString",
                SqlQuery = "SELECT * FROM c order by c._ts desc")]
                IEnumerable<UploadedFile> files,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");
            foreach (UploadedFile file in files)
            {
                log.LogInformation(file.Filename);
            }
            return (ActionResult)new OkObjectResult(files);
        }
    }
}
