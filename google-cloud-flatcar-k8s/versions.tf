# Terraform version and plugin versions

terraform {
  required_version = ">= 0.13.0, < 2.0.0"
  required_providers {
    google = ">= 2.19, < 5.0"
    null   = ">= 2.1"
    dnsimple = {
        source = "dnsimple/dnsimple"
        version = ">= 1.1.2"
    }
    ct = {
      source  = "poseidon/ct"
      version = "~> 0.11"
    }
  }
}

provider "dnsimple" {
  token = var.dnsimple_token
  account = var.dnsimple_account_id
}
