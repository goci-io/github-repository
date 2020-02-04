locals {
  repository_name   = var.create_repository ? join("", github_repository.repository.*.name) : var.repository_name
  repository_remote = format("git@%s:%s/%s.git", var.github_base_url, var.github_organization, local.repository_name)
  repository_dir    = format("%s/repository", abspath(path.module))
}

resource "github_repository" "repository" {
  count              = var.create_repository ? 1 : 0
  name               = var.repository_name
  private            = var.repository_visibility_private
  description        = var.repository_description
  homepage_url       = var.homepage_url
  topics             = var.topics
  gitignore_template = var.gitignore_template
  license_template   = var.license_template
}

resource "github_branch_protection" "master" {
  count          = var.create_branch_protection ? 1 : 0
  depends_on     = [
    module.sync_actions_commit,
  ]

  repository     = local.repository_name
  branch         = "master"
  enforce_admins = true

  required_pull_request_reviews {
    dismiss_stale_reviews = false
  }

  # Status check context cannot be created right now
  #required_status_checks {}
}
