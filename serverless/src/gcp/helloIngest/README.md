# HelloIngest

A simple data pipeline that ingests CSV files into bigquery whenever one is uploaded to a cloud storage bucket.

When a file is upoaded, this triggers a pubsub event, that triggers an ingest cloud function, creating a table matching the file name of the uploaded file in bigquery:

```mermaid
flowchart TD
  workstation[You\nYour Laptop] --> |file_upload| upload_bucket
  upload_bucket[Upload Bucket\nCloud Storage] --> upload_event[Upload Event\nCloud Pub/Sub]
  upload_event --> ingest_function[helloIngest\nIngest CSV file\nCloud Function] --> bigquery_dataset[ingest\nBigQuery Dataset] --> bigquery_table[filename_csv\nBigquery Table]
```

## Perequisites

Using the google cloud sdk <https://console.cloud.google.com/home/dashboard?project=serverless-labs-328806&cloudshell=true>

**or** locally installing the following dependencies

* gcloud sdk (for deploying)
* node.js (for local development)
* jsonquery (jq) for json formatting of output

## Deploying Manually

This section describes how to deploy using the gcloud CLI:

**NOTE:** In serverless-labs everyone runs their labs in the same project. This requires that we separate everything using a unique prefix. Whenever the instruction state `<your prefix>`, replace it with a unique prefix, such as a few characters from your first and last names.

1. Clone the repo:

    ```sh
    git clone https://github.com/ffcg/serverless-lab.git
    cd serverless-lab/src/helloIngest
    ```

1. Create a pubsub topic, see <https://cloud.google.com/pubsub/docs/admin>

    ```sh
    gcloud pubsub topics create <your prefix>-hello-event
    ```

1. Create a pubsub notification on file change, see <https://cloud.google.com/storage/docs/pubsub-notifications>

    **Note:** since bucket names are globally unique, it's best to add the project name to your storage bucket name. Add a personal prefix to the bucket name to separate it from other lab members

    Create the bucket and add a file change notification:

    ```sh
    gsutil mb -b on -l EU gs://<your prefix>-serverless-labs-32880-upload-bucket
    
    gsutil notification create \
        -t <your prefix>-hello-event \
        -f json \
        -e OBJECT_FINALIZE \
        -m prefix:<your prefix> \
        gs://<your prefix>-serverless-labs-32880-upload-bucket
    ```

    This publishes an event to the topic `<your prefix>-hello-event` with `json` payload, when an object is created `OBJECT_FINALIZE` with an additional attribute `prefix` whenever a file uploaded to your bucket. 

    For more info about gsutil commands, see <https://cloud.google.com/storage/docs/gsutil/commands/mb> and <https://cloud.google.com/storage/docs/reporting-changes#gsutil>

1. Deploy the function, see <https://cloud.google.com/functions/docs/calling/pubsub>:

    In the folder containing the helloIngest source:

    for example:

    ```sh
    cd src/gcp/helloIngest
    gcloud functions deploy <your prefix>-hello-event \
      --entry-point helloEvent \
      --runtime=nodejs14 \
      --trigger-topic=<your prefix>-hello-event \
      --trigger-resource=google.pubsub.topic.publish \
      --region=europe-west1
    ```

1. Download a CSV file, or bring your own:
    ```sh
    curl -O https://storage.googleapis.com/cloud-samples-data/bigquery/us-states/us-states.csv
    ```

    *TIP:* There are plenty of CSV:s avauilable at <https://people.sc.fsu.edu/~jburkardt/data/csv/csv.html>.

1. Upload a file:

    **Note** A content type header must be supplied or the cloud function will skip processing of the file unless it's `text/csv`.

    Files can be uploaded to the cloud console: https://console.cloud.google.com/storage/browse, click your upload bucket `<your prefix>-serverless-labs-328806-upload-bucket`, drag and drop files, or click upload.

    Files can also be uploaded using `curl`. This requires adding an authorization header and content type header for the file type to be successfilly identified. csv files should be `text/csv`.

    ```sh
    curl -v --upload-file my-file.txt \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: text/csv" \
    'https://storage.googleapis.com/my-bucket/my-file.txt'
    ```

    **Example**

    ```sh
    curl --upload-file us-states.csv \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: text/csv" \
    'https://storage.googleapis.com/jonasahnstedt-serverless-labs-328806-upload-bucket/us-states.csv'
    ```

1. Check the result of the function:

    browse to <https://console.cloud.google.com/functions/list?referrer=search&project=serverless-labs-328806>, click your function and select the logs tab.

1. Browse to biquery, and check that tables have been created under your dataset. Select a table and click preview to view the contents.

    <https://console.cloud.google.com/bigquery?referrer=search&project=serverless-labs-328806>

    Expand the `serverless-labs-328806` dataset 
    

## Local Development

The implementation is currently missing:
- unit tests, see <https://github.com/GoogleCloudPlatform/nodejs-docs-samples/tree/main/functions/pubsub/test>
- testing and developing, see <https://cloud.google.com/functions/docs/calling/pubsub>


## Terraform

This function is deployed to GCP using the event_function module, see [terraform/gcp](../../../terraform/gcp/README.md)