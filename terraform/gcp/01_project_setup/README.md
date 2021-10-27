# Project Setup

This contains a separate terraform configuration and state for one-off configurations for the project that will either break functionality or settings that cannot be deleted, causing the terraform state to be stuck.

## Prerequisites

* terraform 1.0.x
* gcloud sdk

## Usage

1. Log in using the google cloud sdk:

    ```sh
    gcloud init
    ```

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

    ```terminal
    terraform init -upgrade
    ```

1. Deploy Changes

    ```terminal
    terraform apply
    ```
