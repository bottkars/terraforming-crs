output "ddve_private_ip" {
  value       = module.ddve[0].ddve_private_ip_address
  description = "The private ip address for all jumphost"
}

output "atos_account" {
value = module.ddve[0].atos_account
}