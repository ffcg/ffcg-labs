# Serverless lab

The purpose of this lab is to give you an understanding of setting up a set of cloud services through Infrastructure as Code, using Terraform and Google Cloud Platform.

The lab requires no coding but you are encouraged to look at the code to get an understanding of what is happening "under the hood". After you have created a cloud setup using Terraform, you will test the cloud setup by uploading a CSV-file (us-states.csv) and watch the data be ingested into Big Query.

## Prerequisites

A workstation with the following software installed:

* [Google Cloud SDK](https://cloud.google.com/sdk)
* [git](https://git-scm.com/)
* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

## Directory structure of this repo

The repo contains folders and files used by other labs, for example for Azure, which you can ignore. 

* [`public/`](./public)  - not used in this lab
* [`src/`](./src)  - source code for functions being deployed to GCP
* [`terraform/`](./terraform)  - scripts to generate infrastructure resources and deployment

Each folder contains a README-file further describing the content.

## Instructions

1. Install the software in the Prerequisites section

1. If you are reading these instructions on github: Clone this repo and create your own branch of it locally. Please name the branch, using your name as a variable, e.g. `john-doe` or `jane-doe`.

1. **Terraform Setup:** Change directory to the /terraform/gcp folder. Follow the instructions in the README.md-file in that folder to run the Terraform configuration files locally on your workstation. This will create an infrastructure in the GCP with storage, event handlers, and a data warehouse.

1. Log in to the GUI of your selected cloud provider and try to verify which services has been created. Try to map each module of the Terraform code with the service that was created:

    - Cloud Storage
    - Pub/Sub
    - Big Query

1. Open the *us-states.csv* file locally on your computer to preview the data. Then, upload the file to the "YOUR-PREFIX-upload-bucket" in Cloud Storage using the cloud GUI or with the script below. 

    ```sh
    curl --upload-file us-states.csv \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: text/csv" \
    'https://storage.googleapis.com/YOUR-PREFIX-serverless-labs-328806-upload-bucket/us-states.csv'
    ```

1. Investigate the data as it now should appear in Big Query under `serverless-labs-328806` and the table `YOUR-PREFIX_hello_ingest\us_states.csv`. Feel free to perform some simple analysis (SQL queries) on the data! What happens if you upload a CSV with some other data?

