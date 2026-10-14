# Runbook: Week 1 — Modular Terraform VPC Provisioning 🧱 🏗️

## 1. Triage & Environment Check (Pre-Flight)
Verify that your local MiniStack endpoint and Terraform environment are initialized and authenticated before applying code.
* **Check Terraform version:** `terraform version` (Must be `>= 1.0`)
* **Check local endpoint connection:** Verify local MiniStack/LocalStack container is active.
* **Validate configuration syntax:** Run `terraform validate` in the root terraform directory.

## 2. Execution Steps
Deploy the modular 3-tier VPC with dynamically sliced subnets across available zones.
1. **Initialize providers and modules:**
   ```bash
   terraform init
   ```
2. **Review the execution plan:**

   ```Bash
   terraform plan -out=tfplan
   ```
(Verify that aws_availability_zones correctly discovers available zones and cidrsubnet() cleanly slices public, private, and database subnets without overlapping CIDR blocks).

3. **Apply the configuration:**

    ```Bash
    terraform apply tfplan
    ```
3. **Verification & Sign-Off**

    a. Confirm the infrastructure state converged correctly:

    b. Check state output: Run terraform show or terraform state list to confirm VPC, subnet, route table, and security group resources were successfully created in local state.

    c. Verify local endpoint state: Inspect the local MiniStack/LocalStack dashboard or CLI to ensure resource IDs match your Terraform outputs.
