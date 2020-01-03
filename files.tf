
locals {
  action_names = keys(var.actions)
}

data "null_data_source" "workflows" {
  count = length(var.actions)

  inputs = {
    action = local.action_names[count.index]
    name   = urlencode(yamldecode(file(format("%s/templates/actions/%s.yaml", path.module, local.action_names[count.index]))).name)
  }
}

resource "local_file" "actions" {
  count      = length(var.actions)
  filename   = format("%s/.github/workflows/%s.yml", local.repository_dir, local.action_names[count.index])
  content    = templatefile(format("%s/templates/actions/%s.yaml", path.module, local.action_names[count.index]), merge({
    project_id   = local.project_id,
    account_id   = var.account_id,
  }, var.actions[local.action_names[count.index]]))
}

resource "local_file" "readme" {
  filename   = format("%s/README.md", local.repository_dir)
  content    = templatefile(format("%s/templates/README.md", path.module), {
    repository   = local.repository_name
    description  = var.description
    github_url   = var.github_base_url
    organization = var.github_organization
    workflows    = data.null_data_source.workflows.*.outputs.name
  })
}

resource "null_resource" "clone_repository" {
  provisioner "local-exec" {
    command = "cd ${local.repository_dir} && GIT_SSH_COMMAND='ssh -i ${var.ssh_key_file}' git clone ${local.repository_remote}"
  }

  triggers = {
    actions_hash = md5(join("", local_file.actions.*.content))
  }
}

resource "null_resource" "initial_files" {
  depends_on = [
    local_file.readme,
    local_file.actions,
    null_resource.clone_repository,
  ]

  provisioner "local-exec" {
    command = "${path.module}/scripts/initial.sh ${local.repository_dir} ${local.repository_name} ${var.ssh_key_file}"
  }
}

resource "null_resource" "update_actions" {
  depends_on = [
    null_resource.initial_files,
    null_resource.clone_repository,
  ]

  provisioner "local-exec" {
    command = "${path.module}/scripts/update-actions.sh ${local.repository_dir} ${local.repository_name} ${var.ssh_key_file}"
  }

  triggers = {
    hash = md5(join("", local_file.actions.*.content))
  }
}

resource "null_resource" "cleanup" {
  depends_on = [
    null_resource.update_actions,
  ]

  provisioner "local-exec" {
    command = "rm -rf ${local.repository_dir}/${local.repository_name}"
  }

  triggers = {
    actions_hash = md5(join("", local_file.actions.*.content))
  }
}
