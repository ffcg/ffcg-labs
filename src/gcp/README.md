# GCP source code

Folders in this directoy includes different examples of code running on resources in Google Cloud Platform.

* [helloEvent](./helloIngest/README.md) Writes metadata to a cloud datastore database when files are uploaded to a storage bucket
* [helloWorld](./helloWorld/README.md) Deploys a static site and cloud functions-api that lists files previously uploaded in `helloEvent`
* [helloIngest](./helloIngest/README.md) Ingests CSV file to Bigquery when CSV files are uploaded to a storage bucket

## GCP Solution Overview

The following solution will be deployed when performing this lab or running terraform:

```mermaid
flowchart TD
  workstation[You\nYour Laptop] --> |file_upload| upload_bucket
  upload_bucket[Upload Bucket\nCloud Storage] --> upload_event[Upload Event\nCloud Pub/Sub]
  upload_event --> ingest_function[helloIngest\nIngest CSV file\nCloud Function] --> bigquery_dataset[ingest\nBigQuery Dataset] --> bigquery_table[filename_csv\nBigquery Table]
  upload_event --> datastore_write_function[helloEvent\nStore file info\nCloud Function] --> datastore
  workstation <--> |browse| public_bucket[Static Site\nCloud Storage] <--> |api| datastore_read_function[helloWorld\nRead Datastore\nCloud Function] --> datastore[ kind=Content-type\nCloud Datastore]
```