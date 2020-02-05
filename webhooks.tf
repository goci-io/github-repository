locals {
  webhooks = concat(
    var.webhooks,
    local.atlantis_enabled ? [local.atlantis_webhook] : []
  )
}

resource "random_integer" "pw_length" {
  count = length(local.webhooks)
  min   = 18
  max   = 32
}

resource "random_password" "secret" {
  count            = length(local.webhooks)
  length           = element(random_integer.pw_length.*.result, count.index)
  special          = true
  override_special = "_-=%@$!?#"
}

resource "github_repository_webhook" "webhooks" {
  count      = length(local.webhooks)
  repository = local.repository_name
  events     = lookup(local.webhooks[count.index], "events", ["push"])

  configuration {
    url          = lookup(local.webhooks[count.index], "url")
    secret       = lookup(local.webhooks[count.index], "secret", element(random_password.secret.*.result, count.index))
    content_type = "json"
    insecure_ssl = false
  }
}
