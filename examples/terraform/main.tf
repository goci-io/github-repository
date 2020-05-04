variable "github_token" {}

provider "github" {
  version      = "~> 2.2"
  token        = var.github_token
  organization = "goci-io"
}

module "tf_example_repo" {
  source                        = "../../"
  homepage_url                  = "https://github.com/goci-io/github-repository"
  repository_name               = "goci-repository-setup-example"
  repository_description        = "Example setup of an repository with Terraform workflow using Github Actions"
  gitignore_template            = "Terraform"
  github_organization           = "goci-io"
  repository_visibility_private = false
  repository_checkout_dir       = abspath("${path.module}/checkout")
  status_checks                 = ["Terraform"]
  topics                        = ["terraform", "github", "example"]
  actions = {
    "terraform/validate" = {
      check_format = true
      environment  = {}
    }
    "terraform/apply" = {
      name        = "Terraform Example"
      working_dir = "."
      environment = {}
    }
  }
}
