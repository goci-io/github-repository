locals {
  atlantis_enabled    = var.atlantis_domain != ""
  atlantis_default    = [{ name = "default", workflow = "default", autoplan = true }]
  atlantis_workspaces = length(var.atlantis_workspaces) > 0 ? var.atlantis_workspaces : local.atlantis_default
  atlantis_webhook    = {
    name   = "atlantis"
    url    = format("https://%s/events", var.atlantis_domain)
    events = ["issue_comment", "pull_request"]
    secret = var.atlantis_webhook_secret
  }
}

module "initial_atlantis_commit" {
  source             = "git::https://github.com/goci-io/terraform-git-commit.git?ref=tags/0.2.0"
  commit_depends_on  = [module.sync_additional_commit]
  git_repository     = local.repository_name
  git_organization   = var.github_organization
  git_base_url       = var.github_base_url
  ssh_key_file       = local.ssh_key_file_path
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
      }
    }
  }
}
