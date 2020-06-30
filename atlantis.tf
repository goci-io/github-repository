locals {
  atlantis_enabled    = var.atlantis_domain != "" && var.enabled
  atlantis_default    = [{ name = "default", workflow = "default", autoplan = true }]
  atlantis_workspaces = length(var.atlantis_workspaces) > 0 ? var.atlantis_workspaces : local.atlantis_default
  atlantis_webhook = {
    name   = "atlantis"
    url    = format("https://%s/events", var.atlantis_domain)
    events = ["issue_comment", "pull_request"]
    secret = var.atlantis_webhook_secret
  }
  atlantis_default_project = {
    name       = "main"
    directory  = "."
    tf_version = "0.12.24"
  }
}

module "initial_atlantis_commit" {
  source                  = "git::https://github.com/goci-io/terraform-git-commit.git?ref=tags/0.4.0"
  commit_depends_on       = [module.sync_additional_commit]
  git_repository          = local.repository_name
  git_organization        = var.github_organization
  git_base_url            = var.github_base_url
  ssh_key_file            = local.ssh_key_file_path
  repository_checkout_dir = var.repository_checkout_dir
  templates_root_dir      = abspath(path.module)
  enabled                 = local.atlantis_enabled
  message                 = "[goci] atlantis repo level config"
  branch                  = var.atlantis_branch
  changes                 = var.atlantis_sync_changes
  paths = {
    "templates/atlantis.yaml" = {
      target = "atlantis.yaml"
      data = {
        workspaces = local.atlantis_workspaces
        auto_merge = var.atlantis_enable_automerge
        projects   = length(var.atlantis_projects) < 1 ? [local.atlantis_default_project] : var.atlantis_projects
      }
    }
  }
}
