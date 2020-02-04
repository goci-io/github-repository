locals {
  atlantis_enabled    = length(var.atlantis_modules) > 0
  atlantis_default    = [{ name = "default", workflow = "default", autoplan = true }]
  atlantis_workspaces = length(var.atlantis_workspaces) > 0 ? var.atlantis_workspaces : local.atlantis_default
}

module "initial_atlantis_commit" {
  source             = "git::https://github.com/goci-io/terraform-git-commit.git?ref=master"
  commit_depends_on  = [module.initial_readme_commit]
  git_repository     = local.repository_name
  git_organization   = var.github_organization
  git_base_url       = var.github_base_url
  ssh_key_file       = var.ssh_key_file
  templates_root_dir = abspath(path.module)
  enabled            = local.atlantis_enabled
  message            = "[goci] add initial atlantis repo level config"
  branch             = "master"
  changes            = false
  paths              = {
    "templates/atlantis.yaml" = {
      target = "atlantis.yaml"
      data   = {
        workspaces = local.atlantis_workspaces
        modules    = var.atlantis_modules
      }
    }
  }
}

module "sync_atlantis_commit" {
  source             = "git::https://github.com/goci-io/terraform-git-commit.git?ref=master"
  commit_depends_on  = [module.initial_atlantis_commit]
  git_repository     = local.repository_name
  git_organization   = var.github_organization
  git_base_url       = var.github_base_url
  ssh_key_file       = var.ssh_key_file
  templates_root_dir = abspath(path.module)
  enabled            = local.atlantis_enabled && var.atlantis_sync_enabled
  message            = "[goci] update atlantis.yaml"
  branch             = "goci-update-atlantis"
  changes            = true
  paths              = {
    "templates/atlantis.yaml" = {
      target = "atlantis.yaml"
      data   = {
        workspaces = local.atlantis_workspaces
        modules    = var.atlantis_modules
      }
    }
  }
}
