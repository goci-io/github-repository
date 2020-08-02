resource "random_integer" "pw_length" {
  count = var.enabled ? length(var.webhooks) : 0
  min   = 18
  max   = 32
}

resource "random_password" "secret" {
  count            = var.enabled ? length(var.webhooks) : 0
  length           = element(random_integer.pw_length.*.result, count.index)
  special          = true
  override_special = "_-=%@$!?#"
}

resource "github_repository_webhook" "webhooks" {
  count      = var.enabled ? length(var.webhooks) : 0
  repository = local.repository_name
  events     = lookup(local.webhooks[count.index], "events", ["push"])

  configuration {
    url          = lookup(var.webhooks[count.index], "url")
    secret       = lookup(var.webhooks[count.index], "secret", element(random_password.secret.*.result, count.index))
    content_type = "json"
    insecure_ssl = false
  }
}
