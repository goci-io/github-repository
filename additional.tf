
module "initial_additional_commit" {
  source             = "git::https://github.com/goci-io/terraform-git-commit.git?ref=tags/0.2.0"
  commit_depends_on  = [module.sync_readme_commit]
  git_repository     = local.repository_name
  git_organization   = var.github_organization
  git_base_url       = var.github_base_url
  ssh_key_file       = var.ssh_key_file
  templates_root_dir = var.additional_template_dir
  paths              = var.additional_commits
  message            = "[goci] add initial additional files"
  branch             = "master"
  changes            = false
}

module "sync_additional_commit" {
  source             = "git::https://github.com/goci-io/terraform-git-commit.git?ref=tags/0.2.0"
  commit_depends_on  = [module.initial_additional_commit]
  git_repository     = local.repository_name
  git_organization   = var.github_organization
  git_base_url       = var.github_base_url
  ssh_key_file       = var.ssh_key_file
  templates_root_dir = var.additional_template_dir
  paths              = var.additional_commits
  message            = "[goci] update additional files"
  branch             = "goci-update-files"
  changes            = true
}