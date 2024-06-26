variable "digitalocean_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}

variable "vpc_uuid" {
  description = "The UUID of the VPC where the Droplet will be created"
  type        = string
}
