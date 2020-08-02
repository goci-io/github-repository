
locals {
  action_names    = keys(var.actions)
  actions_enabled = var.enabled && length(local.action_names) > 0
}

data "null_data_source" "actions" {
  count = var.enabled ? length(var.actions) : 0

  inputs = {
    key = "templates/actions/${local.action_names[count.index]}.yaml"
    value = jsonencode({
      target = format(".github/workflows/%s.yaml", replace(local.action_names[count.index], "/", "-"))
      data   = var.actions[local.action_names[count.index]]
    })
  }
}

module "initial_actions_commit" {
  source                  = "git::https://github.com/goci-io/terraform-git-commit.git?ref=tags/0.4.0"
  commit_depends_on       = [module.sync_additional_commit]
  git_repository          = local.repository_name
  git_organization        = var.github_organization
  git_base_url            = var.github_base_url
  ssh_key_file            = local.ssh_key_file_path
  templates_root_dir      = abspath(path.module)
  repository_checkout_dir = var.repository_checkout_dir
  enabled                 = local.actions_enabled && var.create_repository
  message                 = "[goci] add initial github actions"
  branch                  = "master"
  changes                 = false
  paths = zipmap(
    data.null_data_source.actions.*.outputs.key,
    jsondecode(format("[%s]", join(",", data.null_data_source.actions.*.outputs.value)))
  )
}

module "sync_actions_commit" {
  source                  = "git::https://github.com/goci-io/terraform-git-commit.git?ref=tags/0.4.0"
  commit_depends_on       = [module.initial_actions_commit]
  git_repository          = local.repository_name
  git_organization        = var.github_organization
  git_base_url            = var.github_base_url
  ssh_key_file            = local.ssh_key_file_path
  repository_checkout_dir = var.repository_checkout_dir
  templates_root_dir      = abspath(path.module)
  message                 = "[goci] update github actions"
  branch                  = "goci-update-actions"
  changes                 = true
  enabled                 = local.actions_enabled
  paths = zipmap(
    data.null_data_source.actions.*.outputs.key,
    jsondecode(format("[%s]", join(",", data.null_data_source.actions.*.outputs.value)))
  )
}
