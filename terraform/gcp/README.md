# Terraform

## Usage

Create an access token that is valid for 1 hour:

```sh
gcloud init
export GOOGLE_OAUTH_ACCESS_TOKEN=$(gcloud auth print-access-token)
terraform init -upgrade
terraform plan
```