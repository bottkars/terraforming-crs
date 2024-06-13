output "ssh_public_key" {
  sensitive = true
  value     = tls_private_key.cs.public_key_openssh
}

output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.cs.private_key_pem
}