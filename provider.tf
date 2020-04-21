terraform {
  required_version = ">= 0.12.1"

  required_providers {
    template = "~> 2.1"
    random   = "~> 2.2"
    null     = "~> 2.1"
    local    = "~> 1.3"
    tls      = "~> 2.1"
  }
}

provider "github" {
  version      = "~> 2.2"
  individual   = var.is_individual
  organization = var.github_organization
}
