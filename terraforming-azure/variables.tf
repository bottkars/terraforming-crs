/*
Subscription Variables, should be set from env or vault
*/
variable "subscription_id" {

}
variable "tenant_id" {
default = null
}
variable "client_id" {
default = null
}
variable "client_secret" {
default = null
}
variable "location" {
default = null
}
variable "azure_environment" {
  description = "The Azure cloud environment to use. Available values at https://www.terraform.io/docs/providers/azurerm/#environment"
  default     = "public"
}

variable "resourcePrefix" {
  default = "PPCR"
}