variable "project_id" {
  type = string
}

variable "cluster_name" {
  type = string
}


variable "cluster_version_prefix" {
  type = string
  default = "1.27"
}

variable "cluster_version" {
  type = string
  default = null
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
  default = null
}

////////////////
// Networking
////////////////

variable "vpc_main_subnet" {
  type    = string
  default = "10.123.0.0/24"
}

////////////////
// Nodes
////////////////

variable "web_instance_type" {
  type    = string
  default = "e2-standard-2"
}

variable "web_disk_type" {
  type    = string
  default = "pd-standard"
}

variable "web_count" {
  type    = number
  default = 4
}


variable "voip_instance_type" {
  type    = string
  default = "e2-standard-2"
}

variable "voip_disk_type" {
  type    = string
  default = "pd-standard"
}

variable "voip_count" {
  type    = number
  default = 2
}

variable "media_instance_type" {
  type    =  string
  default = "e2-standard-2"
}

variable "media_disk_type" {
  type    = string
  default = "pd-standard"
}

variable "media_count" {
  type    = number
  default = 2
}