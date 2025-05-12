terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "bbot" {
  name   = "bbot-vps"
  image  = "186433879" # Custom snapshot ID with BBOT pre-installed
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  ssh_keys = [var.ssh_fingerprint]
}

output "droplet_ip" {
  value = digitalocean_droplet.bbot.ipv4_address
}