output "ddve_private_ip" {
  value       = module.ddve[0].ddve_private_ip_address
  description = "The private ip address for all jumphost"
}

output "atos_account" {
value = module.ddve[0].atos_account
}


output "ddev_ssh_public_key" {
  sensitive = true
  value     = module.ddve[0].ssh_public_key
}

output "ddve_ssh_private_key" {
  sensitive = true
  value     = module.ddve[0].ssh_private_key
}