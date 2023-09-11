terraform {
  required_providers {
    vultr = {
      source = "vultr/vultr"
      version = "2.15.1"
    }
  }
}

provider "vultr" {
  api_key = var.api_key
}

