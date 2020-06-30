locals {
  repository_secrets = keys(var.action_secrets)
  repository_name    = var.create_repository ? join("", github_repository.repository.*.name) : var.repository_name
  repository_remote  = format("git@%s:%s/%s.git", var.github_base_url, var.github_organization, local.repository_name)
  repository_dir     = format("%s/repository", abspath(path.module))
  status_checks = concat(
    var.status_checks,
    local.atlantis_enabled ? ["atlantis/plan"] : []
  )
}

resource "github_repository" "repository" {
  count                  = var.enabled && var.create_repository ? 1 : 0
  visibility             = var.repository_visibility_private ? "private" : "public"
  name                   = var.repository_name
  description            = var.repository_description
  homepage_url           = var.homepage_url
  topics                 = var.topics
  gitignore_template     = var.gitignore_template
  license_template       = var.license_template
  delete_branch_on_merge = var.delete_branch_on_merge
  has_wiki               = var.enable_wiki
  has_issues             = var.enable_issues
  has_projects           = var.enable_projects

  lifecycle {
    # Can be restored at https://github.com/organizations/<org>/settings/deleted_repositories
    # prevent_destroy = true
  }
}

resource "github_branch_protection" "master" {
  count = var.enabled && var.create_branch_protection ? 1 : 0
  depends_on = [
    module.initial_readme_commit,
    module.initial_actions_commit,
    module.initial_atlantis_commit,
    module.initial_additional_commit,
  ]

  repository     = local.repository_name
  branch         = "master"
  enforce_admins = true

  dynamic "required_pull_request_reviews" {
    for_each = var.require_review ? [1] : []

    content {
      dismiss_stale_reviews = false
    }
  }

  dynamic "required_status_checks" {
    for_each = length(local.status_checks) > 0 ? [1] : []

    content {
      strict   = true
      contexts = local.status_checks
    }
  }
}

resource "github_actions_secret" "secret" {
  count           = var.enabled ? length(local.repository_secrets) : 0
  repository      = local.repository_name
  secret_name     = local.repository_secrets[count.index]
  plaintext_value = lookup(var.action_secrets, local.repository_secrets[count.index])
}

resource "github_issue_label" "label" {
  count       = var.enabled ? length(var.labels) : 0
  repository  = local.repository_name
  name        = lookup(var.labels[count.index], "name")
  color       = lookup(var.labels[count.index], "color")
  description = lookup(var.labels[count.index], "description", "")
}
