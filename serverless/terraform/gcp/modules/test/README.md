# Terratest Development

Terratest tests terraform modules by deploying them and running test probes on the deployed infrastructure and resulting state.

## Prerequisites

golang and terraform are required to execute the tests:

* terraform: <https://www.terraform.io/downloads.html>
* golang: <https://golang.org/doc/install>

## Running

1. Install dependencies

    ```sh
    go get
    ```

1. Activate prerequisite services in test

    ```sh
    terraform init -upgrade
    terraform apply -auto-approve
    ```

1. Run the tests

    ```sh
    go test -v -timeout 30m
    ```

## Creating from scratch

From <https://terratest.gruntwork.io/docs/getting-started/quick-start/>

1. Create a `test` folder in your terraform `modules`

1. Copy the `http_function_test.go` or the example from the getting-started link above

1. Create a new do module and download dependencies

    ```sh
        go mod init github.com/forefront/serveless-labs/terraform/modules/test
        go mod tidy
    ```