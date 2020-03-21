locals {
  generate_ssh_key  = var.public_ssh_key_file == "" || var.ssh_key_file == ""
  ssh_key_file_path = local.generate_ssh_key ? join("", local_file.private_ssh_ci_key.*.filename) : var.ssh_key_file
  public_ssh_key    = local.generate_ssh_key ? join("", tls_private_key.ci_ssh.*.public_key_openssh) : file(var.public_ssh_key_file)
}

resource "tls_private_key" "ci_ssh" {
  count     = local.generate_ssh_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_ssh_ci_key" {
  count             = local.generate_ssh_key ? 1 : 0
  sensitive_content = join("", tls_private_key.ci_ssh.*.private_key_pem)
  filename          = "${path.module}/.ssh/git_rsa"
  file_permission   = "0600"
}

resource "github_repository_deploy_key" "ci" {
  title      = format("%s-tf-deploy", local.repository_name)
  repository = local.repository_name
  key        = local.public_ssh_key
  read_only  = "false"
}
