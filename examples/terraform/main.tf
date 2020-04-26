variable "github_token" {}

provider "github" {
  alias        = "example"
  version      = "~> 2.2"
  organization = "goci-io"
  token        = var.github_token
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
  status_checks                 = ["Terraform Validate"]
  topics                        = ["terraform", "github", "example"]
  actions = {
    "terraform/validate" = {
      check_format = true
      environment  = {}
    }
    "terraform/apply" = {
      name        = "Terraform Example"
      working_dir = "."
      environment = {
        TF_VAR_deploy_ssh_key = "$${{ secrets.EXAMPLE_DEPLOY_KEY }}"
      }
    }
  }

  providers = {
    github = github.example
  }
}
