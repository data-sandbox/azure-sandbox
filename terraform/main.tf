resource "azurerm_resource_group" "functions_rg" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.functions_rg.name
  location                 = azurerm_resource_group.functions_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "service_plan" {
  name                = var.service_plan_name
  resource_group_name = azurerm_resource_group.functions_rg.name
  location            = azurerm_resource_group.functions_rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_function_app" "functions_demo" {
  name                = var.function_app_name
  resource_group_name = azurerm_resource_group.functions_rg.name
  location            = azurerm_resource_group.functions_rg.location

  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan.id

  site_config {
    application_stack {
      python_version = 3.12
    }
  }

}

resource "azurerm_linux_web_app" "web_app_demo" {
  name                = var.web_app_name
  resource_group_name = azurerm_resource_group.functions_rg.name
  location            = azurerm_service_plan.service_plan.location
  service_plan_id     = azurerm_service_plan.service_plan.id

  site_config {
    application_stack {
      python_version = 3.12
    }
  }
}

# TODO application insights resource
