### ⚠️ Architectural Note: The 3a vs. 3b Emulation Boundary
Local emulators like **MiniStack** eliminate AWS billing risk, but production engineers must understand where local simulation ends:
- **Week 3a (Data-Plane Triage & Limits):** We attempt OS-level routing, socket listeners, and packet triage (`curl`, `ss`, `dig`)—and immediately encounter local emulation barriers where raw packet tracing fails.
- **Week 3b (Control-Plane Auditing):** We pivot to querying local control-plane APIs to map endpoint coverage, test un-enforced IAM policies, and document divergence from live multi-AZ AWS environments.
> *Takeaway:* Use MiniStack to master IaC syntax and troubleshoot local limitations before hitting production.

---

## 🧱 The Incremental Stack
Each week layers directly onto the previous phase—building a single, living architecture rather than disconnected toy projects:

1. **Week 1 (IaC Foundations):** Provision the modular 3-tier VPC skeleton using Terraform.
2. **Week 2 (Fleet Admin):** Automate Ubuntu OS config, systemd services, and health checks using Ansible.
3. **Week 3a & 3b (Network Limits & API Triage):** Attempt data-plane traffic paths, discover local packet tracing boundaries, and pivot to auditing MiniStack control-plane limits.
4. **Week 4 (Chaos Engineering):** Intentionally break routing, drop health checks, and log raw failure outputs.
5. **Week 5 (Runbooks, IAM & Compliance):** Codify incident recovery runbooks and run Checkov static security scans.
6. **Week 6 (Portfolio Polish):** Package the codebase and translate technical artifacts into STAR interview narratives.