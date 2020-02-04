
locals {
  action_names = keys(var.actions)
}

data "null_data_source" "actions" {
  count = length(var.actions)

  inputs = {
    key   = "templates/actions/${local.action_names[count.index]}.yaml"
    value = jsonencode({
      target = format(".github/workflows/%s.yaml", local.action_names[count.index])
      data   = var.actions[local.action_names[count.index]]
    })
  }
}

module "initial_actions_commit" {
  source             = "git::https://github.com/goci-io/terraform-git-commit.git?ref=master"
  commit_depends_on  = [module.initial_readme_commit]
  git_repository     = local.repository_name
  git_organization   = var.github_organization
  git_base_url       = var.github_base_url
  ssh_key_file       = var.ssh_key_file
  templates_root_dir = abspath(path.module)
  message            = "[goci] add initial github actions"
  branch             = "master"
  changes            = false
  paths              = zipmap(data.null_data_source.actions.*.outputs.key, jsondecode(format("[%s]", join(",", data.null_data_source.actions.*.outputs.value))))
}

module "sync_actions_commit" {
  source             = "git::https://github.com/goci-io/terraform-git-commit.git?ref=master"
  commit_depends_on  = [module.initial_actions_commit]
  git_repository     = local.repository_name
  git_organization   = var.github_organization
  git_base_url       = var.github_base_url
  ssh_key_file       = var.ssh_key_file
  templates_root_dir = abspath(path.module)
  message            = "[goci] update github actions"
  branch             = "goci-update-actions"
  changes            = true
  paths              = zipmap(data.null_data_source.actions.*.outputs.key, jsondecode(format("[%s]", join(",", data.null_data_source.actions.*.outputs.value))))
}
