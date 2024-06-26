terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.0.0"
    }
  }
}

resource "digitalocean_droplet" "this" {
  image    = var.image
  name     = var.name
  region   = var.region
  size     = var.size
  backups  = var.backups
  ipv6     = var.ipv6
  # vpc_uuid = var.vpc_uuid
  ssh_keys = var.ssh_keys

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.ssh_private_key_path)
    host        = self.ipv4_address
  }

 provisioner "remote-exec" {
    inline = [
      "while sudo fuser /var/lib/dpkg/lock-frontend ; do sleep 1 ; done",
      "apt-get update",
      "apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sh get-docker.sh",
      "systemctl start docker",
      "systemctl enable docker",
      "curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "chmod +x /usr/local/bin/docker-compose",
      "groupadd docker || true",
      "useradd -m -s /bin/bash -p $(openssl passwd -1 ololo) user",
      "usermod -aG docker user",
      "usermod -aG sudo user",  # Добавляем пользователя в группу sudo
      "echo 'user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers",  # Разрешаем использовать sudo без пароля
      "mkdir -p /home/user/.ssh",
      "cp /root/.ssh/authorized_keys /home/user/.ssh/authorized_keys",
      "chown -R user:user /home/user/.ssh",
      "chmod 700 /home/user/.ssh",
      "chmod 600 /home/user/.ssh/authorized_keys"
    ]
  }

  tags = var.tags
}