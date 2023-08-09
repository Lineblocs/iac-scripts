variable "users" {
  type = list(object({
    arn  = string
    name = string
  }))
}

variable "aws_router_instance_type" {
  type = list(string)
  default = ["m5.large"]
}

variable "aws_media_instance_type" {
  type = list(string)
  default = ["m5.large"]
}