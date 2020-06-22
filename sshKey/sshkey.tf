terraform {
  required_version = "~> 0.12.0"

  required_providers {
    aws   = "~> 2.0"
    tls   = "~> 2.0"
    local = "~> 1.3"
    null  = "~> 2.1"
  }
}

##--------------------Define storing files---------------------##
locals {
  depends_on = [aws_key_pair.imported]

  public_key_filename = format(
    "%s/%s%s",
    var.ssh_public_key_path,
    var.key,
    var.public_key_extension
  )

  private_key_filename = format(
    "%s/%s%s",
    var.ssh_public_key_path,
    var.key,
    var.private_key_extension
  )
}
##-----------------Import key if already exists----------------##
resource "aws_key_pair" "imported" {
  count      = var.generate_ssh_key == false ? 1 : 0
  key_name   = var.key
  public_key = file("${var.PATH_TO_PUBLIC_KEY}")
}

##-------------Create SSH key if it doesn't exist-------------##
resource "tls_private_key" "default" {
  count     = var.generate_ssh_key == true ? 1 : 0
  algorithm = var.ssh_key_algorithm
}

resource "aws_key_pair" "generated" {
  count      = var.generate_ssh_key == true ? 1 : 0
  depends_on = [tls_private_key.default]
  key_name   = var.key
  public_key = tls_private_key.default[0].public_key_openssh
}

##-----------------Store key details locally------------------##
resource "local_file" "public_key_openssh" {
  count      = var.generate_ssh_key == true ? 1 : 0
  depends_on = [tls_private_key.default]
  content    = tls_private_key.default[0].public_key_openssh
  filename   = local.public_key_filename
}

resource "local_file" "private_key_pem" {
  count             = var.generate_ssh_key == true ? 1 : 0
  depends_on        = [tls_private_key.default]
  sensitive_content = tls_private_key.default[0].private_key_pem
  filename          = local.private_key_filename
  file_permission   = "0600"
}
