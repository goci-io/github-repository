locals {
  readme_data = {
    repository   = local.repository_name
    description  = var.description
    github_url   = var.github_base_url
    organization = var.github_organization
    prp_team     = var.prp_team
  }
}

module "initial_readme_commit" {
  source                  = "git::https://github.com/goci-io/terraform-git-commit.git?ref=tags/0.4.0"
  commit_depends_on       = [github_repository_deploy_key.ci]
  git_repository          = local.repository_name
  git_organization        = var.github_organization
  git_base_url            = var.github_base_url
  ssh_key_file            = local.ssh_key_file_path
  repository_checkout_dir = var.repository_checkout_dir
  templates_root_dir      = abspath(path.module)
  enabled                 = var.enabled && var.create_readme && var.create_repository
  message                 = "[goci] add initial README.md"
  branch                  = "master"
  changes                 = false
  paths = {
    "templates/README.md" = {
      target = "README.md"
      data   = local.readme_data
    }
  }
}
