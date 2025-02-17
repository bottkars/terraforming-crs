output "ddve_private_ip" {
  value       = [for ddve in module.ddve : ddve.ddve_private_ip_address]
  description = "The private ip addresses for the DDVE Instances"
}
output "ddve_atos_storageaccount" {
  sensitive = true
  value     = [for ddve in module.ddve : ddve.atos_account]
}
output "ddve_atos_container" {
  sensitive = true
  value     = [for ddve in module.ddve : ddve.atos_container]
}


output "ddve_ssh_public_key" {
  value       = [for ddve in module.ddve : ddve.ssh_public_key]
  sensitive   = true
  description = "The ssh public keys for the DDVE Instances"
}


output "ddve_ssh_private_key" {
  sensitive   = true
  value       = [for ddve in module.ddve : ddve.ssh_private_key]
  description = "The ssh private key´s for the DDVE Instances"
}
