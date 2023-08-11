variable "users" {
  type = list(object({
    arn  = string
    name = string
  }))
}


variable "cluster_name" {
  type = string
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

variable "router_instance_type" {
  type    = list(string)
  default = ["m5.large"]
}

variable "router_min_size" {
  type    = number
  default = 2
}

variable "router_max_size" {
  type    = number
  default = 2
}

variable "router_desired_size" {
  type    = number
  default = 2
}

variable "media_instance_type" {
  type    = list(string)
  default = ["m5.large"]
}

variable "media_min_size" {
  type    = number
  default = 4
}

variable "media_max_size" {
  type    = number
  default = 4
}

variable "media_desired_size" {
  type    = number
  default = 4
}