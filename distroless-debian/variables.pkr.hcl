variable "VAGRANT_HCP_CLIENT_ID" {
  type        = string
  sensitive   = true
  description = "client_id of HCP Vagrant service-principle for publishing box"
  default     = env("VAGRANT_HCP_CLIENT_ID")
}

variable "VAGRANT_HCP_CLIENT_SECRET" {
  type        = string
  sensitive   = true
  description = "client_secret of HCP Vagrant service-principle for publishing box"
  default     = env("VAGRANT_HCP_CLIENT_SECRET")
}
