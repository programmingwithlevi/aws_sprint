# 🏃📖 Runbook: Ministack Background Worker & Fleet Administration

## 1. 🧭 Overview & Architecture
This runbook outlines the operational lifecycle, deployment procedures, and emergency triage steps for the hardened background worker deployed via Terraform and Ansible across the local development infrastructure (ubuntu-dev on OrbStack).

### Prerequistes and Environment
* **Target Host:**  ubuntu-dev (Managed via Ansible inventory)

* **Configuration Management:** Ansible (deploy-worker.yml)

* **Service Manager:** systemd with sandboxing, namespace isolation, and strict resource bounding (MemoryMax).

## 2. Standard Operating Procedures (SOPs)
### 2.1 Full Stack Deployment & Reconciliation
To deploy the worker or reconcile any configuration drift against the target environment:

```Bash
ansible-playbook -i inventory/hosts.ini deploy-worker.yml
```
### 2.2 Deep Verbose Triage (Transport & SSH Debugging)
If inventory routing is suspect or connections are dropping, execute the playbook with maximum verbosity (-vvv) to inspect the raw SSH handshake, target interpreter path, and execution payload:

```Bash
ansible-playbook -i inventory/hosts.ini deploy-worker.yml -vvv
```
### 3. Known Failure Modes & Triage
### 3.1 Ambiguous Inventory Routing / Split-Brain Target Drift
Symptom: Ansible reports ok=N and changed=0 even though local configuration files on the target node are corrupted, missing, or mismatched.

Root Cause: Stale or dangling virtual machine instances in the hypervisor runtime (orb list) share overlapping host aliases or IP spaces, causing SSH transport to route commands to an unintended node.

Triage & Resolution:

Inspect active local virtual machines:

```Bash
orb list
```
Terminate any dangling or decommissioned nodes causing namespace pollution:

```Bash
orb delete <stale-vm-name>
```
Verify the target node's hostname and facts explicitly:

```Bash
ansible ubuntu-dev -i inventory/hosts.ini -m setup
```
### 3.2 Configuration Drift & Self-Healing Verification
🤒Symptom: Manual out-of-band edits have corrupted the systemd drop-in override file on the target server.

💊Resolution: Run the Ansible reconciliation playbook. Ansible will overwrite the corrupted file, enforce desired state, issue a systemd daemon-reload, and validate service health assertions automatically.

### 4. Service Health Verification
To confirm the systemd service is active, responsive, and operating within its specified security boundaries on the target host:

```Bash
ssh ubuntu-dev@orb "sudo systemctl status worker-service"
```