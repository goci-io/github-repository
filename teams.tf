locals {
  prp_team_attachment = var.prp_team == "" ? [] : [{ name = var.prp_team }]
  team_attachments    = concat(var.additional_teams, local.prp_team_attachment)
}

resource "github_team" "prp" {
  count       = var.create_team && var.prp_team != "" ? 1 : 0
  description = "Team responsible for repository ${local.repository_name}"
  name        = var.prp_team
}

data "github_team" "prp" {
  depends_on = [github_team.prp]
  count      = length(local.team_attachments)
  slug       = lookup(local.team_attachments[count.index], "name")
}

data "null_data_source" "teams" {
  count = length(local.team_attachments)

  inputs = {
    id         = element(data.github_team.prp.*.id, count.index)
    permission = lookup(local.team_attachments[count.index], "permission", "maintain")
  }
}

resource "github_team_repository" "prp" {
  count      = length(local.team_attachments)
  team_id    = element(data.null_data_source.teams.*.outputs.id, count.index)
  permission = element(data.null_data_source.teams.*.outputs.permission, count.index)
  repository = local.repository_name

  lifecycle {
    ignore_changes = [etag]
  }
}