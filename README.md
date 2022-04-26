# Serverless lab

To run this as a lab, see [GCP_INGEST_LAB.md](GCP_INGEST_LAB.md)

## Prerequisites

Access to [google cloud shell](https://console.cloud.google.com/home/dashboard?project=serverless-labs-328806&cloudshell=true) or **azure cloud shell**, or a workstation with the following software installed:

* [node.js](https://nodejs.org/en/download/)
* [Azure CLI](https://docs.microsoft.com/sv-se/cli/azure/install-azure-cli#install)
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
* [Terraform](https://www.terraform.io/downloads)

## Directory structure of this repo

* [`public/`](./public)  - Contents of a static website that is hosted in a storage bucket
* [`src/`](./src)  - source code for both azure and gcp backends and any frontend
* [`terraform/`](./terraform)  - scripts to generate infrastructure resources and deployment for both Azure and GCP.
