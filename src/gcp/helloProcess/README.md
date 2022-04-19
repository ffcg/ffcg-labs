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

Clone the repo:

```sh
git clone git@github.com:ffcg/serverless-lab.git
cd serverless-lab/src/helloWorld
```

for example:

```sh
gcloud functions deploy jonasahnstedt-hello-world \
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
  url: https://us-central1-serverless-labs-328806.cloudfunctions.net/jonasahnstedt-hello-world
...
```

the endpoint can now be tested using curl.

```sh
curl https://us-central1-serverless-labs-328806.cloudfunctions.net/jonasahnstedt-hello-world
```

The output can be piped jq for better readability.
```sh
curl https://us-central1-serverless-labs-328806.cloudfunctions.net/jonasahnstedt-hello-world | jq
```

If you opted for a non-public url, a bearer token can be added as a header, see <https://cloud.google.com/sdk/gcloud/reference/auth/application-default/print-access-token>:

```sh
curl https://us-central1-serverless-labs-328806.cloudfunctions.net/jonasahnstedt-hello-world \
  -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" | jq
```

For more information about the deploy command, see <https://cloud.google.com/sdk/gcloud/reference/functions/deploy>

## Local Development

We didn't have time to create a proper development environment, and contributions are welcome :)
- unit tests, see <https://github.com/GoogleCloudPlatform/nodejs-docs-samples/tree/main/datastore/functions/test>
- local development, see <https://github.com/GoogleCloudPlatform/nodejs-docs-samples/tree/main/datastore/functions>

## Terraform

This function is deployed to GCP using the event_function module, see [terraform/gcp](../../../terraform/gcp/README.md)