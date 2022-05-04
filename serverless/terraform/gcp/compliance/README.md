# Terraform Compliance

Tests if generated terraform resources adhere to compliance rules written on BDD Gherkin form

## Prerequisites

1. install python:

    <https://www.python.org/downloads/>

1. Install terraform-compliance using pip:

    ```sh
    python -m pip install terraform-compliance
    ```

1. Run terraform plan and generate output, or test your existing state:

  ```sh
  terraform plan -out=plan.out
  terraform state pull > state.out
  ```

1. Test plan or state for compliance:

  ```sh
  terraform-compliance -p plan.out -f ./compliance
  terraform-compliance -p state.out -f ./compliance
  ```