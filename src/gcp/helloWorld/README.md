# HelloEvent

A cloud function that recieves a http request and requests all image entities from cloud datastore, sorted newest first. Currently it won't filter on your entities and you'll get everything in the shared datastore.

## Perequisites

Using the google cloud sdk <https://console.cloud.google.com/home/dashboard?project=serverless-labs-328806&cloudshell=true>

**or** locally installing the following dependencies

* gcloud sdk (for deploying)
* node.js (for local development)
* jsonquery (jq) for json formatting of output

## Deploying

Cloud functions can be deployed using the gui, see <https://cloud.google.com/functions/docs/quickstart-nodejs> or <https://cloud.google.com/functions/docs/deploying/console>.

Or the command line tools, see <https://cloud.google.com/functions/docs/deploying/filesystem>

1. Clone the repo:

    ```sh
    git clone git@github.com:ffcg/serverless-lab.git
    cd serverless-lab/src/helloWorld
    ```

1. Deploy the function:
    
    **Note:** replace the `<your prefix>` part in the instructions with your chosen prefix

    ```sh
    cd src/gcp/helloWorld
    gcloud functions deploy <your prefix>-hello-world \
      --entry-point helloWorld \
      --runtime=nodejs14 \
      --trigger-http \
      --allow-unauthenticated \
      --region=europe-west1
    ```

    the `url` output indicates the public endpoint:

    ```output
    ...
    httpsTrigger:
      securityLevel: SECURE_OPTIONAL
      url: https://europe-west1-serverless-labs-328806.cloudfunctions.net/jonasahnstedt-hello-world
    ...
    ```

1. The endpoint can now be tested using `curl`.

    ```sh
    curl https://europe-west1-serverless-labs-328806.cloudfunctions.net/<your prefix>-hello-world
    ```

    The output can be piped jq for better readability.
    ```sh
    curl https://europe-west1-serverless-labs-328806.cloudfunctions.net/jonasahnstedt-hello-world | jq
    ```
    output:
    ```json
    [
      {
        "image": {
          "name": "cities.csv",
          "selfLink": "https://www.googleapis.com/storage/v1/b/jonasahnstedt-serverless-labs-328806-upload-bucket/o/cities.csv",
          "generation": "1649681229707668",
          "timeCreated": "2022-04-11T12:47:09.796Z",
          "contentType": "text/csv",
          "bucket": "jonasahnstedt-serverless-labs-328806-upload-bucket",
          "updated": "2022-04-11T12:47:09.796Z",
          "storageClass": "STANDARD",
          "md5Hash": "LdOctt5ezEcfo38fKqx1nw==",
          "mediaLink": "https://www.googleapis.com/download/storage/v1/b/jonasahnstedt-serverless-labs-328806-upload-bucket/o/cities.csv?generation=1649681229707668&alt=media",
          "etag": "CJTzwb2FjPcCEAE=",
          "crc32c": "tGrxGg==",
          "timeStorageClassUpdated": "2022-04-11T12:47:09.796Z",
          "id": "jonasahnstedt-serverless-labs-328806-upload-bucket/cities.csv/1649681229707668",
          "kind": "storage#object",
          "size": "8402",
          "metageneration": "1"
        }
      },
    ...
    ]
    ```

    For more information about the deploy command, see <https://cloud.google.com/sdk/gcloud/reference/functions/deploy>

## Deploying the public website

1. Update the `public/index.html` file and change the api endpoint to your cloud function

    ```js
      const apiUrl =
        "https://europe-west1-serverless-labs-328806.cloudfunctions.net/YOUR-PREFIX-hello-world";
    ```

    example:

    ```js
      const apiUrl =
        "https://europe-west1-serverless-labs-328806.cloudfunctions.net/jonasahnstedt-hello-world";
    ```


1. Create the storage bucket for the public website:

    ```sh
    gsutil mb -b on -l EU gs://<your prefix>-serverless-labs-32880-static-site
    ```

1. And copy the files:

    ```sh
    gsutil cp public/* <your prefix>-serverless-labs-328806-static-site
    ```

    ```output
    Copying file://public/404.html [Content-Type=text/html]...
    Copying file://public/README.md [Content-Type=text/markdown]...                 
    Copying file://public/index.html [Content-Type=text/html]...
    ```

1. Make it publicly accessible

    ```sh
    gsutil iam ch allUsers:objectViewer gs://<your prefix>-serverless-labs-328806-static-site
    ```

    example:

    ```sh
    gsutil iam ch allUsers:objectViewer gs://jonasahnstedt-serverless-labs-328806-static-site
    ```

1. Browse to your new webpage:

    `https://storage.googleapis.com/<your-prefix>-serverless-labs-328806-static-site/index.html`

    example:

    <https://storage.googleapis.com/jonasahnstedt-serverless-labs-328806-static-site/index.html>

1. Resetting the cache:

    By default, any file uploaded to the bucket is cached for 60 minutes, if you forgot to update the prefix (like i did) you can disable caching for the uploaded files so that changes are reflected on your site:

    ```sh
    gsutil -m setmeta -h "Cache-Control:no-cache" gs://<your prefix>-serverless-labs-328806-static-site/*
    ```
    ```output
    Setting metadata on gs://jonasahnstedt-serverless-labs-328806-static-site/404.html...
    Setting metadata on gs://jonasahnstedt-serverless-labs-328806-static-site/index.html...
    Setting metadata on gs://jonasahnstedt-serverless-labs-328806-static-site/README.md...
    ```

1. Check the contents of your datastore:

    browse to: `https://storage.googleapis.com/<your prefix>-serverless-labs-328806-static-site/index.html`

## Local Development

We didn't have time to create a proper development environment, and contributions are welcome :)
- unit tests, see <https://github.com/GoogleCloudPlatform/nodejs-docs-samples/tree/main/datastore/functions/test>
- local development, see <https://github.com/GoogleCloudPlatform/nodejs-docs-samples/tree/main/datastore/functions>

## Terraform

This function is deployed to GCP using the event_function module, see [terraform/gcp](../../../terraform/gcp/README.md)