terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

provider "proxmox" {
  endpoint  = "https://192.168.8.100:8006/"
  api_token = var.proxmox_api_token
  insecure  = true
}

data "proxmox_virtual_environment_nodes" "all" {}

output "nodes" {
  value = data.proxmox_virtual_environment_nodes.all.names
}

resource "proxmox_virtual_environment_download_file" "ubuntu_image" {
  node_name    = "proxmox"
  datastore_id = "local"
  content_type = "iso"
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  file_name    = "noble-server-cloudimg-amd64.img"
}
