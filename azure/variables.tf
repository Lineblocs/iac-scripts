variable "cluster_name" {
  type = string
}


variable "cluster_version" {
  type = string
  default = "1.27"
}

variable "location" {
  type = string
}


////////////////
// Nodes
////////////////

variable "default_node_count" {
  type = number
  default = 1
}

variable "default_instance_type" {
  type    = string
  default = "Standard_B2s"
}

variable "web_instance_type" {
  type    = string
  default = "Standard_B2s"
}

variable "web_count" {
  type    = number
  default = 4
}


variable "voip_instance_type" {
  type    = string
  default = "Standard_B2s"
}

variable "voip_count" {
  type    = number
  default = 2
}

variable "media_instance_type" {
  type    =  string
  default = "Standard_B2s"
}

variable "media_count" {
  type    = number
  default = 2
}