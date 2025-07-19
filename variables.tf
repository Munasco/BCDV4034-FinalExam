# Variable definitions for AKS Terraform configuration

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "East US"

  validation {
    condition = contains([
      "East US", "East US 2", "West US", "West US 2", "West US 3",
      "Central US", "North Central US", "South Central US", "West Central US",
      "Canada Central", "Canada East", "Brazil South", "UK South", "UK West",
      "West Europe", "North Europe", "France Central", "Germany West Central",
      "Switzerland North", "Norway East", "Sweden Central", "UAE North",
      "South Africa North", "Australia East", "Australia Southeast",
      "Southeast Asia", "East Asia", "Japan East", "Japan West",
      "Korea Central", "Korea South", "India Central", "India South",
      "India West"
    ], var.location)
    error_message = "The location must be a valid Azure region."
  }
}

variable "node_count" {
  description = "The number of nodes in the default node pool"
  type        = number
  default     = 2

  validation {
    condition     = var.node_count >= 1 && var.node_count <= 10
    error_message = "Node count must be between 1 and 10."
  }
}

variable "vm_size" {
  description = "The size of the Virtual Machine for the node pool"
  type        = string
  default     = "Standard_D2s_v3"

  validation {
    condition = contains([
      "Standard_D2s_v3", "Standard_D4s_v3", "Standard_D8s_v3",
      "Standard_B2s", "Standard_B4ms", "Standard_B8ms",
      "Standard_D2_v3", "Standard_D4_v3", "Standard_D8_v3",
      "Standard_DS2_v2", "Standard_DS3_v2", "Standard_DS4_v2"
    ], var.vm_size)
    error_message = "VM size must be a valid Azure VM size."
  }
}

variable "enable_auto_scaling" {
  description = "Enable auto-scaling for the default node pool"
  type        = bool
  default     = true
}

variable "min_count" {
  description = "Minimum number of nodes when auto-scaling is enabled"
  type        = number
  default     = 1

  validation {
    condition     = var.min_count >= 1 && var.min_count <= 5
    error_message = "Minimum count must be between 1 and 5."
  }
}

variable "max_count" {
  description = "Maximum number of nodes when auto-scaling is enabled"
  type        = number
  default     = 3

  validation {
    condition     = var.max_count >= 2 && var.max_count <= 20
    error_message = "Maximum count must be between 2 and 20."
  }
}

variable "kubernetes_version" {
  description = "Version of Kubernetes specified when creating the AKS managed cluster"
  type        = string
  default     = null
}

variable "enable_azure_policy" {
  description = "Enable Azure Policy add-on for the cluster"
  type        = bool
  default     = true
}

variable "network_plugin" {
  description = "Network plugin to use for networking (azure or kubenet)"
  type        = string
  default     = "kubenet"

  validation {
    condition     = contains(["azure", "kubenet"], var.network_plugin)
    error_message = "Network plugin must be either 'azure' or 'kubenet'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "AKS-Terraform"
    ManagedBy   = "Terraform"
  }
}
