# MiniStack 🏷️ Infrastructure & Compliance 🔍 Runbook
### 1. Overview 🧭
This repository manages local cloud infrastructure using Terraform and a local emulation runtime (MiniStack). To ensure production readiness, the repository includes an automated compliance auditor (audit-check.sh) that validates resource configurations against strict security and governance baselines before code is deployed.

### 2. Environment & Prerequisites
Runtime Endpoint: http://localhost:4566

## 🔧🔩 Core Tooling:

* **Terraform (~> 4.0 or higher)**

* **AWS CLI (aws configured with --endpoint-url=http://localhost:4566 or awslocal)**

* **jq (command-line JSON processor)**

* **Bash (for running audit automation scripts)**

### 3. Architecture & Core Resources
* **A. Compute Instances**
Definition: Defined in main.tf and app.tf using the aws_instance resource.

* **Compliance Baseline: All active running instances must include mandatory tags, specifically Environment = "dev", to prevent untagged ghost resources from polluting environments.**

* **B. Network Security Groups**
Definition: Custom security groups tied to the VPC configuration.

Compliance Baseline: Ingress rules are audited for overly permissive exposures. Rules permitting unrestricted inbound access (0.0.0.0/0) on non-default security groups are flagged as high-risk compliance errors.

* **C. Storage (DynamoDB)**
Definition: Managed via the Terraform AWS DynamoDB module (ministack-table).

Compliance Baseline:

Table status must be ACTIVE.

Billing mode defaults to on-demand (PAY_PER_REQUEST).

Server-Side Encryption (SSE) must be explicitly enabled (server_side_encryption_enabled = true).

### 4. Emulation-Aware Engineering (MiniStack Caveats)
* **Running against a local emulator provides rapid feedback loops for control-plane configurations, but engineers must account for inherent emulation limitations:**

1. Control Plane vs. Data Plane: MiniStack validates AWS API contracts, resource creation, and state synchronization successfully. However, it cannot emulate true low-level data-plane behavior (such as packet sniffing, routing hops across physical interfaces, or virtualized packet-loss tracing).

2. Ghost Resources: Local emulators can leave terminated or stopped state artifacts in local databases. Compliance scripts must explicitly filter resource queries (e.g., .State.Name == "running") to avoid false positives.

### 5. Running the Compliance Audit
* **The compliance script (audit-check.sh) queries the local endpoint, evaluates active state, generates a structured JSON telemetry report (audit-report.json), and exits with strict shell exit codes (0 for success, 1 for compliance failure).**

#### Execution Command:
```Bash
./audit-check.sh
Report Output Structure (audit-report.json):
JSON
{
  "timestamp": "2026-10-07T15:00:00Z",
  "status": "CHECKED",
  "instances": [
    {
      "InstanceId": "i-0123456789abcdef0",
      "VpcId": "vpc-7273efeb151207e85",
      "SubnetId": "subnet-01234567",
      "Environment": "dev"
    }
  ],
  "security_groups": [
    {
      "GroupId": "sg-470436e8b88c8ce4c",
      "GroupName": "ministack-vpc-default",
      "OpenToWorld": false
    }
  ],
  "database": {
    "TableName": "ministack-table",
    "TableStatus": "ACTIVE",
    "BillingMode": "PAY_PER_REQUEST",
    "EncryptionStatus": "ENABLED",
    "DeletionProtection": false,
    "ItemCount": 0
  }
}
```
### 6. Troubleshooting & Common Gotchas
* **AWS CLI Pager Traps: Large outputs from aws CLI commands may open a terminal pager (less). Press q to exit the pager and return to the prompt.**

* **jq Syntax on Object Literals: When evaluating conditions inside jq object definitions (e.g., checking array lengths), wrap the expression in parentheses ([ ... ] | length > 0) to prevent syntax parsing errors.**

* **Emulator Resets: If local state becomes desynchronized, re-initialize the environment with a clean Terraform state refresh:**

```Bash
terraform destroy -auto-approve
terraform apply -auto-approve
```