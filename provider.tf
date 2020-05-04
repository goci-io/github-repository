terraform {
  required_version = ">= 0.12.1"

  required_providers {
    template = "~> 2.1"
    random   = "~> 2.2"
    github   = "~> 2.2"
    null     = "~> 2.1"
    local    = "~> 1.3"
    tls      = "~> 2.1"
  }
}
