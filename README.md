# aws_sprint 🎁 100% Free • No Credit Card Required 💳🚫
A zero-cost, zero-credit-card cloud engineering sprint. Master enterprise infrastructure, modular IaC, and control-plane auditing locally with zero billing risk using open-source software.

## 🗺️ 6-Week Sprint Roadmap ⚡🏃⚡
`MiniStack` is a free, local-first infrastructure laboratory designed to build, automate, and harden production-grade cloud environments from scratch.

- **Week 1  (Terraform Foundations):** Provisioning a modular 3-tier VPC topology using local MiniStack endpoints.
- **Week 2  (Linux Fleet Admin):** Automating Ubuntu host configuration, systemd services, and health checks with Ansible.
- **Week 3a (Network Packet Flows):** Wiring cross-tier connectivity and executing data-plane triage (`curl`, `ss`, `dig`).
- **Week 3b (Emulation Boundaries):** Auditing local control-plane APIs to map MiniStack emulation limits against real AWS.
- **Week 4  (Chaos Engineering):** Simulating production failures, dropping routes, and logging raw diagnostic trails.
- **Week 5  (Runbooks, IAM & Compliance):** Drafting standardized incident runbooks and scanning IaC/IAM via Checkov.
- **Week 6  (Portfolio Polish):** Packaging technical artifacts into enterprise documentation and STAR interview narratives.

---

## 🚀 Quick-Start Guide 

### Prerequisites & Environment
- **Environment / Hypervisor:** OrbStack (recommended) or Docker Desktop / local container runtimes.
- **Container Engine:** Docker `>= 20.10`
- **Target OS:** Ubuntu 24.04 LTS (running locally)
- **Infrastructure-as-Code:** Terraform `>= 1.0`
- **Configuration Management:** Ansible `>= 2.10`
- **Compliance & Security:** Checkov (for static IaC and IAM analysis)

### Quick-Start: Provision Infrastructure (Terraform)
Navigate to the terraform directory, initialize the environment, and apply the infrastructure configuration:
```bash
cd terraform/
terraform init
terraform apply