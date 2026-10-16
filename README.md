# MiniStack CloudOps: Local IaC Deployment & Learning Framework

> A $0-cost, hands-on local AWS testing environment and high-density, text-based operational runbook. No credit card required. 

[![Terraform](https://img.shields.io/badge/IaC-Terraform_1.5+-623CE4?logo=terraform)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/Automation-Ansible-EE0000?logo=ansible)](https://www.ansible.com/)
[![Security](https://img.shields.io/badge/Security-Checkov_Passed-0052CC)](https://www.checkov.io/)
[![Linting](https://img.shields.io/badge/Linting-ShellCheck_Clean-4EAA25)](https://www.shellcheck.net/)

---

## Summary

This repository provides a fully local, reproducible infrastructure lab designed to build, audit, and secure cloud environments using open-source tools—without a credit card or financial risk. 

By pairing **MiniStack control-plane emulation** with **modular Terraform** and **Ansible fleet automation**, this framework allows operators and learners to iterate on production-grade infrastructure concepts locally.

### Key Highlights
* **Zero Financial Barrier:** Developed a completely local AWS testing pipeline to eliminate accidental billing spikes and credit card requirements.
* **Streamlined Learning Path:** Replaced lengthy, video-heavy tutorials with high-density, text-based operational runbooks.
* **Production Security Guardrails:** Integrated static IaC security scanning (`Checkov`) and shell script auditing (`ShellCheck`) directly into the local workflow.
* **Control-Plane Observability:** Mapped emulation boundaries and established state drift detection mechanisms using `terraform plan` and dry-run CLI diagnostic scripts.

---

## System Architecture & Tech Stack

```text
+-------------------------------------------------------------------+
|                        Local Host Environment                     |
|                                                                   |
|   +-------------------+       +-------------------------------+   |
|   |  Terraform (IaC)  | ----> |           MiniStack           |   |
|   |  Modular VPCs/IAM |       |   (Control-Plane Emulation)   |   |
|   +-------------------+       +-------------------------------+   |
|             |                                 |                   |
|             v                                 v                   |
|   +-------------------+       +-------------------------------+   |
|   | Ansible Playbooks | ----> | Local EC2 / Docker Instances  |   |
|   | Fleet Management  |       | (Data-Plane Nodes)            |   |
|   +-------------------+       +-------------------------------+   |
|                                                                   |
|   Security & Compliance: Checkov (IaC) | ShellCheck (Scripts)     |
+-------------------------------------------------------------------+
```

* **Infrastructure Provisioning:** Terraform (Modular VPC, subnets, route tables, security groups).
* **Fleet Configuration:** Ansible (Node provisioning, host hardening, automated configuration).
* **Cloud Emulation:** MiniStack / LocalStack (AWS S3, EC2, IAM, and STS API mocking).
* **Code Quality & Compliance:** Checkov static security analysis & ShellCheck bash linting.

---

## 6-Week Sprint Framework

This repository documents a structured 6-week hands-on progression covering foundational cloud operations, state reconciliation, and security compliance:

| Phase | Operational Focus | Technical Deliverables & Lab Artifacts |
| :--- | :--- | :--- |
| **Week 1** | **Modular 3-Tier IaC** | Provisioned a modular, multi-AZ local VPC using Terraform with isolated subnet boundaries and security groups. |
| **Week 2** | **Fleet Administration** | Automated host configuration and node provisioning using Ansible playbooks on emulated Linux instances. |
| **Week 3** | **Control-Plane Auditing** | Mapped MiniStack API emulation boundaries; built dry-run CLI diagnostic scripts using `awslocal` and `jq`. |
| **Week 4** | **State Drift & Security** | Executed automated state drift reconciliation using `terraform plan`; integrated Checkov and ShellCheck static analysis. |
| **Week 5** | **Least-Privilege IAM** | Authored scoped IAM policies and evaluated boundary conditions under local emulation constraints. |
| **Week 6** | **Portfolio & Alignment** | Packaged operational runbooks, documented failure modes, and mapped technical outcomes to enterprise standards. |

---

## Quickstart Runbook

### Prerequisites
* Docker & OrbStack / Docker Desktop
* Terraform 1.5+
* Python 3.10+ / Ansible
* `awslocal` CLI wrapper

### 1. Clone & Validate Environment
```bash
# Clone
git clone [https://github.com/your-username/ministack-cloudops.git](https://github.com/your-username/ministack-cloudops.git)
cd ministack-cloudops
```
```
# Run static security and linting checks
checkov -d ./terraform
shellcheck ./scripts/*.sh
```
```
# Initialize and apply modular Terraform against MiniStack
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```
## Pedagogical Design & Instructional Philosophy:
Traditional cloud learning environments often force a choice between high financial risk (live cloud accounts) or passive consumption (watching dozens of hours of video lectures).

This framework applies structured instructional design to solve both friction points:

Decoupling Risk from Learning: By keeping execution 100% local, learners can experiment, break configurations, and debug state drift with zero anxiety over unexpected billing.

Active, Text-Based Execution: Replaces verbose video tutorials with actionable, step-by-step technical runbooks that mirror real-world documentation standards.