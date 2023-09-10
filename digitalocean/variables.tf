variable "kube_version" {
  description = "Version to use"
  type        = string
  default     = "1.22"
}

variable "do_token" {
  description = "Digital Ocean Personal access token"
  type        = string
  default     = ""
}

variable "do_region" {
  description = "Digital Ocean region (e.g. `fra1` => Frankfurt)"
  type        = string
  default     = "tor1"
}

////////////////
// Nodes
////////////////

variable "cluster_name" {
  description = "Digital Ocean Kubernetes cluster name (e.g. `k8s-do`)"
  type        = string
  default     = "lineblocs-k8s-do"
}

variable "web_type" {
  description = "Digital Ocean Kubernetes web node pool type (e.g. `s-1vcpu-2gb` => 1vCPU, 2GB RAM)"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "web_min_nodes" {
  description = "Digital Ocean Kubernetes web node pool size (e.g. `3`)"
  type        = number
  default     = 1
}

variable "web_max_nodes" {
  description = "Digital Ocean Kubernetes web node pool size (e.g. `3`)"
  type        = number
  default     = 2
}

variable "voip_type" {
  description = "Digital Ocean Kubernetes additional node pool type (e.g. `s-1vcpu-2gb` => 1vCPU, 2GB RAM)"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "voip_min_nodes" {
  description = "Digital Ocean Kubernetes voip node pool size (e.g. `3`)"
  type        = number
  default     = 1
}

variable "voip_max_nodes" {
  description = "Digital Ocean Kubernetes voip node pool size (e.g. `3`)"
  type        = number
  default     = 2
}

variable "media_type" {
  description = "Digital Ocean Kubernetes media node pool type (e.g. `s-1vcpu-2gb` => 1vCPU, 2GB RAM)"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "media_min_nodes" {
  description = "Digital Ocean Kubernetes media node pool size (e.g. `3`)"
  type        = number
  default     = 1
}

variable "media_max_nodes" {
  description = "Digital Ocean Kubernetes additional node pool size (e.g. `3`)"
  type        = number
  default     = 2
}