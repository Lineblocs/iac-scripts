variable "enable_digitalocean" {
  description = "Enable / Disable Digital Ocean (e.g. `true`)"
  type        = bool
  default     = true
}

variable "kube_version" {
  description = "Version to use"
  type        = string
  default     = "1.22"
}
variable "random_cluster_suffix" {
  description = "Random 6 byte hex suffix for cluster name"
  type        = string
  default     = ""
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

variable "do_k8s_name" {
  description = "Digital Ocean Kubernetes cluster name (e.g. `k8s-do`)"
  type        = string
  default     = "lineblocs-k8s-do"
}

variable "do_k8s_pool_name" {
  description = "Digital Ocean Kubernetes default node pool name (e.g. `k8s-do-nodepool`)"
  type        = string
  default     = "lineblocs-k8s-mainpool"
}

variable "do_k8s_nodes" {
  description = "Digital Ocean Kubernetes default node pool size (e.g. `2`)"
  type        = number
  default     = 2
}

variable "do_k8s_node_type" {
  description = "Digital Ocean Kubernetes default node pool type (e.g. `s-1vcpu-2gb` => 1vCPU, 2GB RAM)"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "do_k8s_nodepool_name" {
  description = "Digital Ocean Kubernetes additional node pool name (e.g. `k8s-do-nodepool`)"
  type        = string
  default     = "lineblocs-k8s-nodepool"
}

variable "do_k8s_nodepool_type" {
  description = "Digital Ocean Kubernetes additional node pool type (e.g. `s-1vcpu-2gb` => 1vCPU, 2GB RAM)"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "do_k8s_nodepool_size" {
  description = "Digital Ocean Kubernetes additional node pool size (e.g. `3`)"
  type        = number
  default     = 2
}

variable "do_k8s_media_nodepool_name" {
  description = "Digital Ocean Kubernetes additional node pool name (e.g. `k8s-do-nodepool`)"
  type        = string
  default     = "lineblocs-k8s-media-nodepool"
}

variable "do_k8s_media_nodepool_type" {
  description = "Digital Ocean Kubernetes additional node pool type (e.g. `s-1vcpu-2gb` => 1vCPU, 2GB RAM)"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "do_k8s_media_nodepool_min_nodes" {
  description = "Digital Ocean Kubernetes additional node pool size (e.g. `3`)"
  type        = number
  default     = 1
}

variable "do_k8s_media_nodepool_max_nodes" {
  description = "Digital Ocean Kubernetes additional node pool size (e.g. `3`)"
  type        = number
  default     = 2
}

variable "do_k8s_media_nodepool_size" {
  description = "Digital Ocean Kubernetes additional node pool size (e.g. `3`)"
  type        = number
  default     = 6
}