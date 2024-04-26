output "jumphost_private_ip" {
  value       = module.jumphost.jumphost_private_ip_address
  description = "The private ip address for all jumphost"
}