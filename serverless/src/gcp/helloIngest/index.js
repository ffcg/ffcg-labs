// https://cloud.google.com/bigquery/docs/samples/bigquery-load-table-gcs-csv-autodetect
//Global scope may be reused between calls
const {BigQuery} = require('@google-cloud/bigquery');
const {Storage} = require('@google-cloud/storage');

// Instantiate clients
const bigquery = new BigQuery();
const storage = new Storage();

// [START functions_pubsub_subscribe]
/**
 * Triggered from a message on a Cloud Pub/Sub topic.
 *
 * @param {object} pubsubMessage The Cloud Pub/Sub Message object.
 * @param {string} pubsubMessage.data The "data" property of the Cloud Pub/Sub Message.
 * @param {string} pubsubMessage.attributes The "attribute" property of the Cloud Pub/Sub Message.
 */
exports.helloIngest = async pubsubMessage => {

  // Read the Data from the pubsub message, example message data is available below
  data = JSON.parse(Buffer.from(pubsubMessage.data, 'base64'))
  attributes = pubsubMessage.attributes

  if (data.contentType == "text/csv") {
    const datasetId = process.env.DATASET_ID || "hello_ingest";
    // create a table with your prefix, and the filename containing only lowercase letters and underscore
    const tableId = `${data.name}`.toLowerCase().replace(/[^a-z0-9]/g,"_"); //replace(/[^\p{L}\p{M}\p{N}]/g,"_");
    const bucketName = data.bucket
    const filename = data.name
  
    // Configure the load job. For full list of options, see:
    // https://cloud.google.com/bigquery/docs/reference/rest/v2/Job#JobConfigurationLoad
    const metadata = {
      sourceFormat: 'CSV',
      skipLeadingRows: 1,
      allowQuotedNewlines: true,
      autodetect: true,
      location: 'EU',
      // Truncate duplicates, see https://googleapis.dev/python/bigquery/latest/generated/google.cloud.bigquery.job.WriteDisposition.html
      writeDisposition: 'WRITE_TRUNCATE',
    };
  
    // Load data from a Google Cloud Storage file into the table
    const [job] = await bigquery
      .dataset(datasetId)
      .table(tableId)
      .load(storage
          .bucket(bucketName)
          .file(filename),
        metadata);
    // load() waits for the job to finish
    console.log(`Job ${job.id} completed.`);
  } else {
    console.log(`skipping content type ${data.contentType}.`);
  }
}
// [END functions_pubsub_subscribe]

/*
//Example message data
{
  "kind": "storage#object",
  "id": "ja-serverless-labs-328806-upload-bucket/requirements.csv/1635079916677007",
  "selfLink": "https://www.googleapis.com/storage/v1/b/ja-serverless-labs-328806-upload-bucket/o/requirements.csv",
  "name": "requirements.csv",
  "bucket": "ja-serverless-labs-328806-upload-bucket",
  "generation": "1635079916677007",
  "metageneration": "1",
  "contentType": "text/csv",
  "timeCreated": "2021-10-24T12:51:56.755Z",
  "updated": "2021-10-24T12:51:56.755Z",
  "storageClass": "STANDARD",
  "timeStorageClassUpdated": "2021-10-24T12:51:56.755Z",
  "size": "57",
  "md5Hash": "hXDoTtCpY//ABGgciC396A==",
  "mediaLink": "https://www.googleapis.com/download/storage/v1/b/ja-serverless-labs-328806-upload-bucket/o/requirements.csv?generation=1635079916677007&alt=media",
  "crc32c": "VL6FPQ==",
  "etag": "CI/P86yL4/MCEAE="
}
//Example message atributes
{
  "prefix": "ja"
}
*/