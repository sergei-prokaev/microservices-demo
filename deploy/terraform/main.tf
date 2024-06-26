terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.0.0"
    }
  }
}

provider "digitalocean" {
  token = var.digitalocean_token
}

data "digitalocean_ssh_key" "default" {
  name = "SergeyMacAir"
}

module "master" {
  source = "./modules/droplet"

  image    = "ubuntu-20-04-x64"
  name     = "master-server"
  region   = "nyc1"
  size     = "s-2vcpu-4gb"
  backups  = false
  ipv6     = true
  vpc_uuid = var.vpc_uuid
  ssh_keys = [data.digitalocean_ssh_key.default.id]
  ssh_private_key_path = var.ssh_private_key_path
  tags     = ["web"]
}

module "worker" {
  source = "./modules/droplet"

  image    = "ubuntu-20-04-x64"
  name     = "worker-server"
  region   = "nyc1"
  size     = "s-2vcpu-4gb"
  backups  = false
  ipv6     = true
  vpc_uuid = var.vpc_uuid
  ssh_keys = [data.digitalocean_ssh_key.default.id]
  ssh_private_key_path = var.ssh_private_key_path
  tags     = ["worker"]
}