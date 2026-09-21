resource "proxmox_virtual_environment_vm" "devops" {
  name      = "devops-vm"
  node_name = "proxmox"
  vm_id     = 201

  agent {
    enabled = false
  }

  cpu {
    cores = 3
    type  = "host"
  }

  memory {
    dedicated = 8192
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_image.id
    interface    = "scsi0"
    size         = 40
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.8.150/24"
        gateway = "192.168.8.1"
      }
    }

    user_account {
      username = "ubuntu"
      keys     = [trimspace(file(pathexpand("~/.ssh/id_ed25519.pub")))]
    }
  }
}
