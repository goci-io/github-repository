locals {
  repository_name   = var.create_repository ? join("", github_repository.repository.*.name) : var.repository_name
  repository_remote = format("git@%s:%s/%s.git", var.github_base_url, var.github_organization, local.repository_name)
  repository_dir    = format("%s/repository", abspath(path.module))
  status_checks     = concat(
    var.status_checks, 
    local.atlantis_enabled ? ["atlantis/plan", "atlantis/apply"] : []
  )
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
    module.initial_readme_commit,
    module.initial_actions_commit,
    module.initial_atlantis_commit,
    module.initial_additional_commit,
  ]

  repository     = local.repository_name
  branch         = "master"
  enforce_admins = true

  required_pull_request_reviews {
    dismiss_stale_reviews = false
  }

  dynamic "required_status_checks" {
    for_each = length(local.status_checks) > 0 ? [1] : []

    content {
      strict   = true
      contexts = local.status_checks
    }
  }
}

data "github_team" "prp" {
  count = var.prp_team == "" ? 0 : 1
  slug  = var.prp_team
}

resource "github_team_repository" "prp" {
  count      = var.prp_team == "" ? 0 : 1
  team_id    = join("", data.github_team.prp.*.id)
  repository = local.repository_name
  permission = "maintain"
}
