# 🔒 Security & 🔑 Access-Control Runbook: Least-Privilege IAM for Local Emulation

## 1. Architecture Overview & Threat Modeling

In a production cloud environment, blast-radius containment is non-negotiable. To adhere strictly to the principle of least privilege, our 3-tier MiniStack architecture enforces rigid role segregation between compute nodes, configuration stores, and telemetry backends.

- **Compute Tier Identity (`ministack-app-compute-role`):** A dedicated IAM role assumed exclusively by our EC2 compute instances (`ec2.amazonaws.com`).
- **Configuration Scoping:** Rather than relying on sweeping service wildcards (e.g., `ssm:*`), the instance is granted access to read only its specific application secret ARN: `arn:aws:ssm:us-east-1:<account-id>:parameter/ministack/prod/db_password`.
- **Instance Profile Integration:** Because EC2 instances consume IAM roles via instance metadata rather than direct role bindings, an `aws_iam_instance_profile` wrapper (`ministack-app-instance-profile`) bridges the role to the compute resource.

---

## 2. 🛡️ Modular Terraform 🏰 IAM Configuration (`iam.tf`)

Our infrastructure-as-code configuration abstracts account boundaries using parameterized variables, ensuring the exact same HCL module remains portable between local sandboxes and enterprise AWS landing zones.

```hcl
variable "aws_account_id" {
  type    = string
  default = "000000000000" # MiniStack fallback default
}

variable "aws_region_name" {
  type    = string
  default = "us-east-1"
}

# 1. The Trust Policy (AssumeRole) for our EC2 compute tier
resource "aws_iam_role" "app_compute_role" {
  name = "ministack-app-compute-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# 2. Least-Privilege Policy for Parameter Store (No wildcards!)
resource "aws_iam_policy" "app_ssm_policy" {
  name        = "ministack-app-ssm-policy"
  description = "Allows compute tier to read only the production database password parameter"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ssm:GetParameter"
        Resource = "arn:aws:ssm:${var.aws_region_name}:${var.aws_account_id}:parameter/ministack/prod/db_password"
      }
    ]
  })
}

# 3. Bind the policy to the role
resource "aws_iam_role_policy_attachment" "app_attachment" {
  role       = aws_iam_role.app_compute_role.name
  policy_arn = aws_iam_policy.app_ssm_policy.arn
}

# 4. Instance Profile wrapper for EC2 attachment
resource "aws_iam_instance_profile" "app_profile" {
  name = "ministack-app-instance-profile"
  role = aws_iam_role.app_compute_role.name
}
```

---

## 3. Policy Simulation & Auditing via `awslocal`

Before application deployment, permissions are verified using the local emulator CLI wrapper (`awslocal`) to confirm that policy evaluation decisions return expected access boundaries.

To test whether our compute role is authorized to read the production database parameter:
```bash
awslocal iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::000000000000:role/ministack-app-compute-role \
  --action-names ssm:GetParameter \
  --resource-arns arn:aws:ssm:us-east-1:000000000000:parameter/ministack/prod/db_password
```
- **Expected Result:** `"EvalDecision": "allowed"`

To test negative assertions (verifying unauthorized actions are blocked):
```bash
awslocal iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::000000000000:role/ministack-app-compute-role \
  --action-names ssm:DeleteParameter \
  --resource-arns arn:aws:ssm:us-east-1:000000000000:parameter/ministack/prod/db_password
```
- **Expected Result:** `"EvalDecision": "implicitDeny"` or `"explicitDeny"`

---

## 4. The Local IAM Emulation Gap

When engineering infrastructure that runs against local single-process emulators like MiniStack, engineers must account for several critical differences compared to a true enterprise AWS cloud environment:

| Feature / Behavior | MiniStack (Local Sandbox) | Enterprise AWS Landing Zone |
| :--- | :--- | :--- |
| **Account ID Resolution** | Defaults to static fallback strings (`000000000000`) and local loopback endpoints. | Dynamically resolved via global cryptographic STS endpoints returning genuine 12-digit organization IDs. |
| **STS & Credential Validation** | Requires provider-level endpoint overrides and bypass flags (`skip_requesting_account_id = true`, etc.) to prevent `InvalidClientTokenId` errors. | Validates Signature Version 4 (SigV4) cryptographically against regional AWS STS and IAM control planes natively. |
| **Policy Enforcement Defaults** | May simplify mock evaluations or bypass strict checks depending on control-plane configuration flags (`AUTH=true`). | Always natively enforced by the backend IAM service engine with zero bypasses. |
```