output "ppcr_ssh_public_key" {
  sensitive = true
  value     = module.ppcr.ssh_public_key 
}

output "ppcr_ssh_private_key" {
  sensitive = true
  value     = module.ppcr.ssh_private_key 
}

output "ppcr_private_ip" {
  value       = module.ppcr.ppcr_private_ip_address
  description = "The private ip address for all ppcr"
}


output "privatelink" {
  value       = module.ddve[0].privatelink
  description = "The private ip address for the Private link"
}