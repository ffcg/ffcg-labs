# HelloIngest

A cloud function that recieves a cloud storage event through google pubsub and imports an uploaded CSV file to bigquery.

## Perequisites

Using the google cloud sdk <https://console.cloud.google.com/home/dashboard?project=serverless-labs-328806&cloudshell=true>

**or** locally installing the following dependencies

* gcloud sdk (for deploying)
* node.js (for local development)
* jsonquery (jq) for json formatting of output

## Deploying Manually

Cloud functions can be deployed using the gui, see <https://cloud.google.com/functions/docs/quickstart-nodejs> or <https://cloud.google.com/functions/docs/deploying/console>.

Or the command line tools, see <https://cloud.google.com/functions/docs/deploying/filesystem>

1. Clone the repo:

    ```sh
    git clone git@github.com:ffcg/serverless-lab.git
    cd serverless-lab/src/helloIngest
    ```

1. Create a pubsub topic, see <https://cloud.google.com/pubsub/docs/admin>

    ```sh
    gcloud pubsub topics create <your prefix>-hello-event
    ```

1. Create a pubsub notification on file change, see <https://cloud.google.com/storage/docs/pubsub-notifications>

    **Note:** since bucket names are globally unique, it's best to add the project name to your storage bucket name. Add a personal prefix to the bucket name to separate it from other lab members

    Create the bucket and add a file change notification, see <https://cloud.google.com/storage/docs/gsutil/commands/mb> and <https://cloud.google.com/storage/docs/reporting-changes#gsutil>:

    ```sh
    gsutil mb -b on -l EU gs://<your prefix>-$(gcloud config get-value project)-upload-bucket
    gsutil notification create -t <your prefix>-hello-event -f json -e OBJECT_FINALIZE gs://<your prefix>-$(gcloud config get-value project)-upload-bucket -m prefix=<your prefix>
    ```

1. Deploy the function, see <https://cloud.google.com/functions/docs/calling/pubsub>:

    for example:

    ```sh
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

1. Upload a file:

    **Note** A content type header must be supplied or the cloud function will skip processing of the file

    ```sh
    curl --upload-file <file> \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: text/csv" \
    'https://storage.googleapis.com/<your prefix>-serverless-labs-328806-upload-bucket/<file>'
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

1. 

## Local Development

The implementation is currently missing:
- unit tests, see <https://github.com/GoogleCloudPlatform/nodejs-docs-samples/tree/main/functions/pubsub/test>
- testing and developing, see <https://cloud.google.com/functions/docs/calling/pubsub>


## Terraform

This function is deployed to GCP using the event_function module, see [terraform/gcp](../../../terraform/gcp/README.md)