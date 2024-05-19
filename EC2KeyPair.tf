resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.generated_key_name
  public_key = tls_private_key.dev_key.public_key_openssh
}

resource "local_sensitive_file" "this" {
  content  = tls_private_key.dev_key.private_key_openssh
  filename = "./sshkey/${aws_key_pair.key_pair.key_name}.pem"
  file_permission = 400
}