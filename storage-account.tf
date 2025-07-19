# Azure Storage Account for AKS Integration
resource "azurerm_storage_account" "aks_storage" {
  name                     = "staks${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.aks_rg.name
  location                 = azurerm_resource_group.aks_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  # Enable blob storage
  blob_properties {
    versioning_enabled = true
  }

  tags = {
    Environment = "Development"
    Project     = "AKS-Terraform"
    Purpose     = "AKS-Persistent-Storage"
  }
}

# Blob Container for persistent storage
resource "azurerm_storage_container" "aks_blob_container" {
  name                  = "aks-persistent-storage"
  storage_account_name  = azurerm_storage_account.aks_storage.name
  container_access_type = "private"
}

# Azure File Share for AKS persistent volumes
resource "azurerm_storage_share" "aks_file_share" {
  name                 = "aks-persistent-storage"
  storage_account_name = azurerm_storage_account.aks_storage.name
  quota                = 10
}

# Output storage account details
output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.aks_storage.name
}

output "storage_account_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.aks_storage.primary_access_key
  sensitive   = true
}

output "blob_container_name" {
  description = "Name of the blob container"
  value       = azurerm_storage_container.aks_blob_container.name
}

output "file_share_name" {
  description = "Name of the file share"
  value       = azurerm_storage_share.aks_file_share.name
}

output "storage_account_connection_string" {
  description = "Connection string for the storage account"
  value       = azurerm_storage_account.aks_storage.primary_connection_string
  sensitive   = true
} 