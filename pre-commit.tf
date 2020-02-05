
locals {
  precommit_data = {
    repos = var.pre_commit_config
  }
}

module "initial_precommit_commit" {
  source             = "git::https://github.com/goci-io/terraform-git-commit.git?ref=tags/0.2.0"
  commit_depends_on  = [module.initial_readme_commit]
  git_repository     = local.repository_name
  git_organization   = var.github_organization
  git_base_url       = var.github_base_url
  ssh_key_file       = var.ssh_key_file
  templates_root_dir = abspath(path.module)
  message            = "[goci] add initial pre-commit hook config"
  branch             = "master"
  changes            = false
  paths              = {
    "templates/pre-commit-config.yaml" = {
      target = ".pre-commit-config.yaml"
      data   = local.precommit_data
    }
  }
}

module "sync_precommit_commit" {
  source             = "git::https://github.com/goci-io/terraform-git-commit.git?ref=tags/0.2.0"
  commit_depends_on  = [module.initial_precommit_commit]
  git_repository     = local.repository_name
  git_organization   = var.github_organization
  git_base_url       = var.github_base_url
  ssh_key_file       = var.ssh_key_file
  templates_root_dir = abspath(path.module)
  enabled            = var.readme_sync_enabled
  message            = "[goci] update pre-commit hook config"
  branch             = "goci-update-commit-hooks"
  changes            = true
  paths              = {
    "templates/pre-commit-config.yaml" = {
      target = ".pre-commit-config.yaml"
      data   = local.precommit_data
    }
  }
}
