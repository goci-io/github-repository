terraform {
  required_version = ">= 0.12.1"

  required_providers {
    random = "~> 2.2"
    null   = "~> 2.1"
    local  = "~> 1.3"
  }
}

provider "github" {
  version      = "~> 2.2"
  individual   = var.is_individual
  organization = var.github_organization
}
