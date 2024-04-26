output "ppcr_ssh_public_key" {
  sensitive = true
  value     = module.ppcr.ssh_public_key 
}

output "ppcr_ssh_private_key" {
  sensitive = true
  value     = module.ppcr.ssh_private_key 
}