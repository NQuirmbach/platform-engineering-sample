variable "azure_location" {
  description = "Azure Location"
  default     = "westeurope"
}

variable "environment" {
  description = "Current environment"
}

variable "cluster_master_vm_size" {
  description = "Size of the master node VM"
  type        = string
}

variable "cluster_node_vm_size" {
  description = "Size of the master node VM"
  type        = string
}

variable "cluster_node_count" {
  description = "Count of cluster nodes"
  type        = number
}

variable "cluster_ssh_key" {
  description = "Public SSH key"
  type        = string
}
