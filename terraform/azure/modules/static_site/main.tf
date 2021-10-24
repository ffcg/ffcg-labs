resource "azurerm_resource_group" "static_site" {
  name     = "Serverless-kurs"
  location = "West Europe"
}

resource "azurerm_storage_account" "static_site" {
  name                     = var.name
  resource_group_name      = azurerm_resource_group.static_site.name
  location                 = azurerm_resource_group.static_site.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
  static_website {
    index_document = "index.html"
    error_404_document = "404.html"
  }
}

resource "azurerm_storage_blob" "index_file" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.static_site.name
  storage_container_name = "$web"
  content_type           = "text/html"
  type                   = "Block"
  source                 = "${var.source_path}/index.html"
}

resource "azurerm_storage_blob" "error_file" {
  name                   = "404.html"
  storage_account_name   = azurerm_storage_account.static_site.name
  storage_container_name = "$web"
  content_type           = "text/html"
  type                   = "Block"
  source                 = "${var.source_path}/404.html"
}