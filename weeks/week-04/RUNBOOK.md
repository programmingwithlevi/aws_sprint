# Runbook: State Drift & Compliance

## 1. Runtime State Drift Detection
Catch out-of-band modifications against the live MiniStack API.

1. **Sync State:** `terraform apply -parallelism=1`
2. **Simulate Drift:** Manually mutate a resource tag or attribute.
3. **Analyze Drift:** `terraform plan`
   - *Expected:* Outputs an update plan (`~`) identifying live divergence.

---

## 2. Static Compliance Auditing
Scan declarative HCL code on disk via **Checkov** prior to deployment.

1. **Run Scan:** `checkov -d .`
2. **Coverage:** Catches hardcoded secrets, unencrypted storage, and policy violations.

---

## Verification Summary

| Mechanism | Tool | Target | Purpose |
| :--- | :--- | :--- | :--- |
| **Runtime Drift** | `terraform plan` | Live MiniStack API | Detects manual/out-of-band resource changes. |
| **Static Compliance** | `checkov -d .` | Local HCL Code | Enforces security baselines before deployment. |

---

## ⚠️ Emulation Boundary
Enforcing aggressive production runtime flags in MiniStack can trigger `empty result` instantiation errors. **Rule:** Use MiniStack for core primitive validation; enforce strict metadata policies via CI/CD lint gates.