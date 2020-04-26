variable "github_token" {}

module "tf_example_repo" {
  source                        = "../../"
  homepage_url                  = "https://github.com/goci-io/github-repository"
  repository_name               = "goci-repository-setup-example"
  repository_description        = "Example setup of an repository with Terraform workflow using Github Actions"
  gitignore_template            = "Terraform"
  github_organization           = "goci-io"
  github_token                  = var.github_token
  repository_visibility_private = false
  create_repository             = false # Manually created to remove need of state file
  repository_checkout_dir       = abspath("${path.module}/checkout")
  status_checks                 = ["Terraform Format", "Terraform Plan"]
  topics                        = ["terraform", "github", "example"]
  actions = {
    "terraform/format" = {}
    "terraform/plan" = {
      environment = {}
      working_dir = "."
    }
    "terraform/apply" = {
      name        = "Terraform Example"
      working_dir = "."
      environment = {}
    }
  }
}
