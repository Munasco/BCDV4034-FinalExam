# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "aks_rg" {
  name     = "rg-aks-${random_string.suffix.result}"
  location = var.location

  tags = {
    Environment = "Development"
    Project     = "AKS-Terraform"
  }
}

# Generate random string for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Create Azure Kubernetes Service (AKS) cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cluster-${random_string.suffix.result}"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "aks-${random_string.suffix.result}"

  # Default node pool configuration
  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size

    # Enable auto-scaling (optional)
    enable_auto_scaling = var.enable_auto_scaling
    min_count           = var.min_count
    max_count           = var.max_count

    # Node pool configuration
    os_disk_size_gb = 30
    type            = "VirtualMachineScaleSets"

    tags = {
      Environment = "Development"
      NodePool    = "default"
    }
  }

  # Identity configuration - System Assigned Managed Identity
  identity {
    type = "SystemAssigned"
  }

  # Storage profile configuration
  storage_profile {
    blob_driver_enabled         = true
    disk_driver_enabled         = true
    file_driver_enabled         = true
    snapshot_controller_enabled = true
  }

  # Network configuration
  network_profile {
    network_plugin    = var.network_plugin
    load_balancer_sku = "standard"
  }

  # Azure Policy Add-on (optional)
  azure_policy_enabled = var.enable_azure_policy

  # HTTP Application Routing (optional - for development)
  http_application_routing_enabled = false

  # Role-based access control
  role_based_access_control_enabled = true

  tags = var.tags
}
