# aws_sprint
A self-directed six-week sprint toward AWS CloudOps Associate-level competency with Ministack.

## 🗺️ Project Overview & 6-Week Sprint Roadmap
`ministack` is a local-first infrastructure laboratory designed to build, automate, and harden production-grade cloud environments from scratch. This repository tracks a rigorous 6-week engineering sprint bridging local hypervisor virtualization, infrastructure-as-code, and fleet management.

* **Week 1: Modular 3-Tier Infrastructure** — Establishing local endpoints, VPC patterns, and modular Terraform deployments.
* **Week 2: Linux Fleet Administration & System Health** — Transitioning to automated state reconciliation with **Ansible**, systemd service hardening, and rigorous transport triage targeting **Ubuntu Linux**.
* **Week 3:** *(Upcoming)* Cloud Architecture & Network Topologies.
* **Week 4:** *(Upcoming)* Identity, Access Management, and Security Guardrails.
* **Week 5:** *(Upcoming)* Observability, Telemetry, and Log Pipelines.
* **Week 6:** *(Upcoming)* Final Production Deployment & Disaster Recovery Simulation.

---

## 🚀 Quick-Start Guide (Current Stage: Week 2)

### Prerequisites & Environment
* **Target OS:** Ubuntu 24.04 LTS (`ubuntu-dev` node running via OrbStack hypervisor)
* **Hypervisor CLI:** OrbStack (`orb`)
* **Infrastructure-as-Code:** Terraform `>= 1.0`
* **Configuration Management:** Ansible `>= 2.10`

### Week 1: Provision Infrastructure (Terraform)
Navigate to the terraform directory, initialize the environment, and apply the infrastructure configuration:
```bash
cd terraform/
terraform init
terraform apply
