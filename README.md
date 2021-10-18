# Serverless lab

## Prerequisites

Access to **google cloud shell** or **azure cloud shell**, or a workstation with the following software installed:

* [node.js](https://nodejs.org/en/download/)
* [Azure CLI](https://docs.microsoft.com/sv-se/cli/azure/install-azure-cli#install)
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)

## Directory structure of this repo

* [`public/`](./public)  - any static files to host, independent of infrastructure
* [`src/`](./src)  - source code for both azure and gcp backends and any frontend
* [`terraform/`](./terraform)  - scripts to generate infrastructure resources and deployment for both Azure and GCP.

## Instructions

Course participants clones this repo and works in their own branch. Name the branch after yourself, e.g. `john-doe` or `jane-doe`.

### Your task

### Examination

Examination will be in the form of a [one minute madness](#what-is-one-minute-madness-presentation)-session where each participant presents what he or she have created. Each participants gets only 60 seconds to present and only one slide is allowed. The slide can have any content but must use the provided template which has a each participants name as header.

### What is one minute madness presentation

One minute madness is a presentation format common within academia where a large number of PhD students present their work at a research conference. Each student is given 60 seconds on stage to talk about his/her research and then immediatly after it is time for the next speaker.
