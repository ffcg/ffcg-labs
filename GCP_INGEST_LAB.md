# GCP Ingest LAB

The purpose of this lab is to show how to ingest batch data in GCP in increasingly automated ways.

The lab requires no coding but you are encouraged to look at the code to get an understanding of what is happening "under the hood". After you have created a cloud setup using Terraform, you will test the cloud setup by uploading a CSV-file (us-states.csv) and watch the data be ingested into Big Query.

1. Manual Ingest using the cloud console

1. Event-driven ingest pipeline using gcloud CLI

1. Event-driven ingest pipeline using infrastructure as code (terraform)

## Prerequisites

Access to [google cloud shell](https://console.cloud.google.com/home/dashboard?project=serverless-labs-328806&cloudshell=true) 

or if you prefer to use your own laptop:

* [Google Cloud SDK](https://cloud.google.com/sdk)
* [git](https://git-scm.com/)
* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [jq](https://stedolan.github.io/jq/download/)

## Directory structure of this repo

The repo contains folders and files used by other labs, for example for Azure, which you can ignore. 

* [`public/`](./public)  - not used in this lab
* [`src/`](./src)  - source code for functions being deployed to GCP
* [`terraform/`](./terraform)  - scripts to generate infrastructure resources and deployment

Each folder contains a README-file further describing the content.

## Instructions

1. Install the software in the Prerequisites section, or browse to [google cloud shell](https://console.cloud.google.com/home/dashboard?project=serverless-labs-328806&cloudshell=true) or **azure cloud shell**,

## Manual Ingest using the Cloud Console

Premise: A Colleague asks you to make a CSV file available in the data warehouse. It's a one-off that will never happen agan, so automation is not strictly neccessary. Even though the instructions are simple, you're the only one with access to be able to ingest the data.

This lab section is hosted by qwiklabs, follow the instructions at <https://partner.cloudskillsboost.google/focuses/12049?parent=catalog>.

If you do not have access to partner qwiklabs, the instructions are available here, <https://www.cloudskillsboost.google/focuses/3692?parent=catalog>

### Step-by-step if you don't have access

1. Open up the bigquery console:

    Browse to the bigquery console: <https://console.cloud.google.com/bigquery?project=serverless-labs-328806>

1. Create a Dataset

    1. Click the **Hambuerger Menu** next to your project **serverless-labs-328860** and click `Create Dataset`.

    1. In the **Dataset ID** field, enter a unique name for your dataset

    1. In the **Data location** field, enter `EU`

    1. Click **Create Dataset**

1. Create a table from CSV

    1. Expand the project **serverless-labs-328860**

    1. Click the **Hambuerger Menu** next to your dataset and Click **Create Table**

    1. In the **Create Table** form, Click **Create Table From**, and select `Upload`

    1. Click **Browse** next to the **Select File** Field, and select the [hw_25000.csv](./terraform/gcp/hw_25000.csv) file.

    1. Enter `hw_25000` in the **Table** Field

    1. Under **Schema** select `Auto Detect`

    1. Click **Query** to open a query window

    1. Enter your query and click **run** to execute the query

        Note the text stating `This query will process 585.94 KB when run.`. GCP provides 10TB of free querying each month, so querying is essentially free for small datasets. 

1. Query the table:

    1. Click the **Hambuerger Menu** next to your dataset and Click **Create Table**

## Event-driven ingest pipeline using gcloud CLI

Premise: The same Colleague now asks you for the third day in a row to make a CSV file available. It's time to automate the process, and make the CSV ingest self-service.

Follow the instructions at [src/gcp/helloIngest](./src/gcp/helloIngest/README.md) to create a pipelie that automatically ingests csv files in a storage bucket.

## Event-driven ingest pipeline using infrastructure as Code

**NOTE** you should use a `different prefix` than when you deployed manually, otherwise the resources you're trying to create already exist, ad the depoy will fail.

Follow the instructions at [terraform/gcp](./terraform/gcp/README.md). This will deploy more than the just the ingest pipeline, but you only need to consider the ingest parts.

## Validating the result

    After deploying the pipeline manually, or using terraform , you can come back and review the result.

1. Log in to the [cloud console]() and try to verify which services has been created. Try to map each module of the Terraform code with the service that was created:

    - [Cloud Storage](https://console.cloud.google.com/storage/browserproject=serverless-labs-328806)
    - [Pub/Sub](https://console.cloud.google.com/cloudpubsub?project=serverless-labs-328806)
    - [Big Query](https://console.cloud.google.com/bigquery?project=serverless-labs-328806)
    - [Cloud Functions](https://console.cloud.google.com/functions/list?referrer=search&project=serverless-labs-328806)

    For a solution overview, see [src/gcp/helloIngest](./src/gcp/helloIngest/README.md)

## Some SQL fun

1. Open the [us-states.csv](terraform/gcp/us-states.csv) file locally on your computer to preview the data. Then, upload the file to the "YOUR-PREFIX-upload-bucket" in Cloud Storage or using the command below: 

    ```sh
    gsutil cp terraform/gcp/us-states.csv gs://<your prefix>-serverless-labs-328806-upload-bucket
    ```

1. Investigate the data as it now should appear in Big Query under the `serverless-labs-328806` project, `YOUR-PREFIX_hello_ingest` dataset and a table named after your file `us_states.csv`.

1. Question: Have the column names been imported successfully?

    No, for some reason, headings are only imported succesfuly when the CSV contains at least one numerical column

1. Open the [hw_25000.csv](terraform/gcp/hw_25000.csv) file locally on your computer to preview the data. Then, upload the file to the "YOUR-PREFIX-upload-bucket" in Cloud Storage or using the command below: 

1. Question: Have the column names been imported successfully?

1. What's the average height of the group?

    ```sql
    SELECT AVG(Height_Inches_) as average_height FROM `serverless-labs-328806.<your prefix>_hello_ingest.hw_25000_csv`
    ```

1. What's the average height in m? One inch is 2.54 cm.

    ```sql
    SELECT ... as average_height_cm FROM `serverless-labs-328806.jonasahnstedt_hello_ingest.hw_25000_csv`
    ```

1. What's the average weight in pounts? In kilograms?

    ```sql
    SELECT AVG(Weight_Pounds_) as average_weight FROM `serverless-labs-328806.jonasahnstedt_hello_ingest.hw_25000_csv`
    ```

1. What's the average BMI in the dataset? BMI is defined as weight(kg)/height(m)<sup>2