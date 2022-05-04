terraform {
  backend "gcs" {
    bucket = "serverless-labs-tfstate"
    prefix = "main"
  }
  required_providers {
    google      = {}
    google-beta = {}
  }
}

provider "google" {
  project = "serverless-labs-328806"
  region  = "europe-west1"
  zone    = "europe-west1-a"
}

provider "google-beta" {
  project = "serverless-labs-328806"
  region  = "europe-west1"
  zone    = "europe-west1-a"
}