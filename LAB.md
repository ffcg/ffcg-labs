# Serverless lab

The purpose of this lab is to give you an understanding of setting up a set of cloud services through Infrastructure as Code, using Terraform and Google Cloud Platform.

The lab requires no coding but you are encouraged to look at the code to get an understanding of what is happening "under the hood". After you have created a cloud setup using Terraform, you will test the cloud setup by uploading a CSV-file (us-states.csv) and watch the data be ingested into Big Query.

## Prerequisites

Access to [google cloud shell](https://console.cloud.google.com/home/dashboard?project=serverless-labs-328806&cloudshell=true) or **azure cloud shell**, or a workstation with the following software installed:

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

1. Install the software in the Prerequisites section, or browse to [google cloud shell](https://console.cloud.google.com/home/dashboard?project=serverless-labs-328806&cloudshell=true) or **azure cloud shell**,

## Deploying Manually

Infrastructure can be deployed manually using gcloud-cli or azure-cli, see [src/gcp/README.md](src/gcp/README.md) and [src/azure/README.md](src/azure/README.md).

Follow the `Deploying` section in the readme to set up the solution.

## Deploying Using Terraform

Manual Deployment?

![Ain't nobody got time for that](https://media0.giphy.com/media/bWM2eWYfN3r20/giphy.webp?cid=ecf05e4761b2pi0htcs4yrztb3jpp8lfba29cmfjme6r50mo&rid=giphy.webp&ct=g)

**NOTE** you should use a `different prefix` than when you deployed manually, otherwise the resources you're trying to create already exist.

1. Deploying this function can be done manually by simply copy pasting text from the readme files either directly from github or by cloning the repo to your workstation or cloud shell:

    ```sh
    git clone https://github.com/ffcg/serverless-lab.git
    cd serverless-lab
    ```

1. Infrastructure can be deployed automatically using terraform, see [terraform/gcp/README.md](terraform/gcp/README.md) and [terraform/azure/README.md](terraform/azure/README.md).

    After deploying the terraform code, you can come back and review the result.

1. Log in to the GUI of your selected cloud provider and try to verify which services has been created. Try to map each module of the Terraform code with the service that was created:

    - Cloud Storage
    - Pub/Sub
    - Big Query

    For a solution overview, see [terraform/gcp/README.md](./terraform/gcp/README.md)

1. Open the [us-states.csv](terraform/gcp/us-states.csv) file locally on your computer to preview the data. Then, upload the file to the "YOUR-PREFIX-upload-bucket" in Cloud Storage or using the command below: 

    ```sh
    gsutil cp terraform/gcp/us-states.csv gs://<your prefix>-serverless-labs-328806-upload-bucket
    ```

1. Investigate the data as it now should appear in Big Query under the `serverless-labs-328806` project, `YOUR-PREFIX_hello_ingest` dataset and a table named after your file `us_states.csv`.

1. Question 1: Have the column names been imported successfully?

1. Open the [hw_25000.csv](terraform/gcp/hw_25000.csv) file locally on your computer to preview the data. Then, upload the file to the "YOUR-PREFIX-upload-bucket" in Cloud Storage or using the command below: 

1. Question 1: Have the column names been imported successfully?

1. What's the average height of the group?

    ```sql
    SELECT AVG(Height_Inches_) as average_height FROM `serverless-labs-328806.<your prefix>_hello_ingest.hw_25000_csv`
    ```

1. What's the average height in m? One inch is 2.54 cm.

    ```sql
    SELECT ... as average_height_cm FROM `serverless-labs-328806.jonasahnstedt_hello_ingest.hw_25000_csv`
    ```

1. What's the average weight?

    ```sql
    SELECT AVG(Weight_Pounds_) as average_weight FROM `serverless-labs-328806.jonasahnstedt_hello_ingest.hw_25000_csv`
    ```

1. What's the average BMI?