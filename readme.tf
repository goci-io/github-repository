
data "null_data_source" "workflows" {
  count = length(var.actions)

  inputs = {
    action = local.action_names[count.index]
    name   = yamldecode(file(format("%s/templates/actions/%s.yaml", path.module, local.action_names[count.index]))).name
  }
}

locals {
  readme_data = {
    repository   = local.repository_name
    description  = var.description
    github_url   = var.github_base_url
    organization = var.github_organization
    workflows    = data.null_data_source.workflows.*.outputs.name
    prp_team     = var.prp_team
  }
}

module "initial_readme_commit" {
  source             = "git::https://github.com/goci-io/terraform-git-commit.git?ref=tags/0.2.0"
  commit_depends_on  = [github_repository_deploy_key.ci]
  git_repository     = local.repository_name
  git_organization   = var.github_organization
  git_base_url       = var.github_base_url
  ssh_key_file       = local.ssh_key_file_path
  templates_root_dir = abspath(path.module)
  message            = "[goci] add initial README.md"
  branch             = "master"
  changes            = false
  paths              = {
    "templates/README.md" = {
      target = "README.md"
      data   = local.readme_data
    }
  }
}
