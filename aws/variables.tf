variable "users" {
  type = list(object({
    arn  = string
    name = string
  }))
}


variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.27"
}

variable "region" {
  type = string
}

////////////////
// Networking
////////////////

variable "vpc_cidr" {
  type    = string
  default = "10.123.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.123.1.0/24", "10.123.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.123.3.0/24", "10.123.4.0/24"]
}

variable "intra_subnets" {
  type    = list(string)
  default = ["10.123.5.0/24", "10.123.6.0/24"]
}

////////////////
// Nodes
////////////////
variable "media_desired_size" {
  default = 2
  type    = number
}

variable "media_instance_type" {
  default = ["m5.large"]
  type    = list(string)
}

variable "media_max_size" {
  default = 2
  type    = number
}

variable "media_min_size" {
  default = 2
  type    = number
}

variable "voip_desired_size" {
  default = 2
  type    = number
}

variable "voip_instance_type" {
  default = ["m5.large"]
  type    = list(string)
}

variable "voip_max_size" {
  default = 2
  type    = number
}

variable "voip_min_size" {
  default = 2
  type    = number
}

variable "web_desired_size" {
  default = 4
  type    = number
}

variable "web_instance_type" {
  default = ["m5.large"]
  type    = list(string)
}

variable "web_max_size" {
  default = 4
  type    = number
}

variable "web_min_size" {
  default = 4
  type    = number
}