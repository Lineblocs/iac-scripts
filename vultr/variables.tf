variable "cluster_name" {
  type = string
}


variable "cluster_version" {
  type = string
  default = "v1.27.2+1"
}

variable "region" {
  type = string
}

variable "api_key" {
  description = "Vultr API Key"
  type = string
}

////////////////
// Nodes
////////////////
variable "web_instance_type" {
  type    = string
  default = "vc2-2c-4gb"
}

variable "web_count" {
  type    = number
  default = 4
}

variable "voip_instance_type" {
  type    = string
  default = "vc2-2c-4gb"
}

variable "voip_count" {
  type    = number
  default = 2
}

variable "media_instance_type" {
  type    =  string
  default = "vc2-2c-4gb"
}

variable "media_count" {
  type    = number
  default = 2
}