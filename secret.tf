
resource "random_integer" "pw_length" {
  count = var.create_repository && var.create_webhook && var.webhook_push_secret == "" ? 1 : 0
  min   = 18
  max   = 32
}

resource "random_password" "password" {
  count            = var.create_repository && var.create_webhook && var.webhook_push_secret == "" ? 1 : 0
  length           = random_integer.pw_length[0].result
  special          = true
  override_special = "_-=%@$!?#"
}

locals {
  project_id     = var.project_id == "" ? var.repository_name : var.project_id
  webhook_secret = format("%s:%s", local.project_id, coalesce(var.webhook_push_secret, join("", random_password.password.*.result, ["not-set"])))
}
