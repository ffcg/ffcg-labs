# Terraform GCP

Deploys a serverless example that deploys the following:

Files uploaded to cloud storage generate pubsub events that stores metadata about the uploaded image to cloud datastore.
A website hosted in a cloud storage bucket that queries a public API for file names stored in cloud datastore

## Prerequisites

* terraform 1.0.x
* gcloud sdk

**or** using the google cloud sdk <https://console.cloud.google.com/home/dashboard?project=serverless-labs-328806&cloudshell=true>

## Usage

1. Create default credentials

    ```terminal
    gcloud auth application-default login
    ```

    **or**

    Create an access token that is valid for 1 hour and only in the terminal that you execute the command in:

    ```sh
    export GOOGLE_OAUTH_ACCESS_TOKEN=$(gcloud auth print-access-token)
    ```

1. Initialize terraform

    Set a unique prefix, or you'll have a collision with other lab atendees and redeploy each other's resources:

    Recommended is to use only alpha characters, possibly numbers and dashes, but it hasn't been tested.

    ```terminal
    terraform init -upgrade -backend-config="prefix=<your prefix here>"
    ```

    **Example:**

    ```terminal
    terraform init -upgrade -backend-config="prefix=jonasahnstedt"
    ```

1. Deploy Changes

    When queried for a unique prefix, use the same prefix as above:

    ```terminal
    terraform apply
    ```

    ```output
    var.prefix
    The initials or similar of the student for the lab, e.g. ja for John Anderson. Will be used to prefix resources.

    Enter a value: <your prefix here>
    ```

    **Example:**

    ```terminal
    Enter a value: jonasahnstedt
    ```

1. Confirm

    You can evaluate the output to see what has been changed or added, but that's for a different competence track

    ```sh
    Enter a value: yes
    ```

    ```output
    Outputs:

    https_trigger_url = "https://europe-west1-serverless-labs-328806.cloudfunctions.net/ja-hello-world"
    public_url = "https://storage.googleapis.com/ja-serverless-labs-328806-static-site/index.html"
    ```

1. Update the (./public/index.html)[../../public/index.html] page to use the new https_trigger_url

    ```html
    const apiUrl =
        "https://europe-west1-serverless-labs-328806.cloudfunctions.net/myprefix-hello-world";

    ```

1. Redeploy, don't forget to reapply your prefix:

    ```sh
    terraform apply
    ```
