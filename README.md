# Proxmox Infrastructure as Code (IaC) Pipeline

Automated provisioning and configuration of a VM on a local Proxmox server, driven by a single Jenkins pipeline.

## Problem

Manually setting up a server (clicking through Proxmox, installing packages by hand) is slow and hard to reproduce exactly. If the server is lost, rebuilding it takes hours.

## Solution

The entire server — specs, network, and installed services — is defined in code. Rebuilding it is one button press.

```
GitHub ──push──> Jenkins ──> Terraform ──> Proxmox (creates the VM)
                     └─────> Ansible ────> installs & configures services
```

1. **Terraform** provisions an Ubuntu VM on Proxmox (CPU, RAM, disk, static IP, SSH access).
2. **Ansible** installs Docker and deploys Portainer (container UI), Prometheus + Node Exporter (metrics), and Grafana (dashboards).
3. **Jenkins** runs both steps on demand — no manual commands.
4. **GitHub** stores everything, so the setup is versioned and recoverable.

## Stack

Proxmox VE · Terraform · Ansible · Jenkins · Docker · Git/GitHub

## Proof it works

The VM was deliberately deleted from Proxmox and rebuilt using only the Jenkins pipeline:

```
Terraform: Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
Ansible:   ok=5  changed=4  failed=0
```

Full recovery from a single pipeline run, no manual steps.

## Practices applied

- **Idempotency** — re-running against an unchanged server makes zero changes.
- **Secrets management** — tokens/passwords stored as Jenkins credentials, never committed.
- **Least-privilege access** — Jenkins uses a read-only, repo-scoped GitHub deploy key.

## Result

Code defines the infrastructure, a pipeline enforces it, and recovery from failure is one click — verified with a real deletion-and-rebuild test.
