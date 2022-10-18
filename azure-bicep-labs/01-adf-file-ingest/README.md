# Data Engineering in Azure Lab 1

## Overview

## Prerequisites
* [Visual Studio Code](https://code.visualstudio.com/) and optional Extensions (install from VS Code):
    * Bicep
    * SQL Server (mssql)
* [Azure CLI](https://docs.microsoft.com/sv-se/cli/azure/install-azure-cli#install)
* [git](https://git-scm.com/)
* [jq](https://stedolan.github.io/jq/download/)
    * Special note for Win: it is recommended to follow the advice to use Chocolatey
* [SqlServer.exe](https://learn.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage-download?view=sql-server-ver16)
    * Special note for Win: add `C:\Program Files\Microsoft SQL Server\160\DAC\bin` to user Environment Variable `Path`
* For Windows: enable [WSL](https://learn.microsoft.com/en-us/windows/wsl/install)

## Directory structure
* [`modules/`](./modules) - Bicep modules used in this lab to deploy necessary resources in Azure
* [`projects/`](./projects) - storage of projects used in this lab. Contains a single MS SQL Database project `lab_db` with a single table [`dbo.taxi_rides`](./projects/lab_db/tables/taxi_rides.sql)
* [`0_deploy.sh`](./0_deploy.sh) - Main deployment script of this lab
* [`1_deploy_storage.bicep`](./1_deploy_storage.bicep) - Bicep module used by the deployment script
* [`2_deploy_process.bicep`](./2_deploy_process.bicep) - Bicep module used by the deployment script