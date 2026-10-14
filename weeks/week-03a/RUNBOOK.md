# Runbook: Week 3a — 🔴🟡🟢 Network Triage & Emulation Boundaries
**This runbook documents the data-plane network limits discovered while testing multi-tier architectures locally. Rather than a failure, hitting these boundaries is an intentional exploration of local emulation limits versus live cloud behavior.**

## 🚨 1. Pre-Flight Safety Valve (whois Check)
Local emulators can occasionally generate mock public IP strings that accidentally overlap with live public IPv4 blocks owned by third parties. Never run raw network traffic tools without verifying your endpoint.

**Extract Target IP:**

```Bash
terraform output -raw instance_public_ip
```
***Run Ownership Check:***

```Bash
whois $(terraform output -raw instance_public_ip)
```
☝️✨ **Safety Rule:** If the lookup returns commercial enterprise data (e.g., Amazon Technologies Inc.) instead of private/loopback space, stop immediately. Do not route local container traffic to external IPs.

## 🔍 2. The Emulation Boundary (Data Plane vs. Control Plane)
Our initial workflow assumed standard enterprise packet tracing. However, we hit a hard structural wall:

**Control Plane (Fully Supported):** Terraform state, VPC layouts, subnets, and API security group bindings work seamlessly.

**Data Plane (Unsupported):** MiniStack manages mock APIs but lacks a hypervisor kernel, guest ENIs, or container network stacks for emulated instances. Attempting data-plane packet tracing (curl -iv, traceroute) against mock instance IPs results in timeouts or accidental routing to the live public internet.

## 💥 3. Chaos Injection & The External ELB Surprise
**The Experiment:** We injected deliberate chaos to test security group enforcement:

**Modify security.tf:** We stripped all inbound rules from our public web security group ```(ingress = []).```

**Apply State:** Ran terraform apply to record the change in the local mock control plane.

**Validate Blockage:** Attempted to validate the expected traffic blockage using data-plane tools like ```curl -iv``` and ```traceroute.```

What Actually Happened
Instead of timing out or being dropped by a local firewall, the request completed a successful TLS handshake with a real, live external Amazon ELB ```(54.233.134.244)```, returning a 403 Forbidden response.

***Why a Private ELB Doesn't Help:***

  *Switching to a private ELB wouldn't solve this limitation. The root issue isn't public routing; it's that MiniStack lacks an active guest data-plane interface. The mock IP resolved to an external address, and because there is no underlying guest firewall daemon to enforce rules on a real data stream, the security group change had zero actual effect on network traffic.*

## 🛠️ 4. The Correct Control-Plane Verification Workflow
Because data-plane tools (```curl```, ```traceroute```) fail or mislead against emulated instance IPs, engineers must audit architecture strictly through the control-plane API.

Audit Command
Query the MiniStack API directly using awslocal and jq to verify resource bindings:

```Bash
awslocal ec2 describe-instances --instance-ids <instance-id> | jq '.Reservations[0].Instances[0] | {InstanceId, State: .State.Name, SecurityGroups}'
```
**Expected Baseline Output:**

````
JSON
{
  "InstanceId": "i-fedf1f201093edc5b",
  "State": "running",
  "SecurityGroups": [
    {
      "GroupId": "sg-470436e8b88c8ce4c",
      "GroupName": "public-web-sg"
    }
  ]
}
```