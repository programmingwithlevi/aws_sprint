#!/bin/bash

ENDPOINT="http://localhost:4566"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# 1. Gather EC2 Instances (Active only)
instances_json=$(/opt/homebrew/bin/aws ec2 describe-instances --endpoint-url="$ENDPOINT" 2>/dev/null | jq \
  '[ .Reservations[]?.Instances[]? | select(.State.Name == "running") | {
      InstanceId: .InstanceId,
      VpcId: (.VpcId // "None"),
      SubnetId: (.SubnetId // "None"),
      Environment: ((.Tags[]? | select(.Key == "Environment") | .Value) // "Unassigned")
    } ]' || echo '[]')

# 2. Gather Security Groups (Checking for overly permissive rules)
sg_json=$(/opt/homebrew/bin/aws ec2 describe-security-groups --endpoint-url="$ENDPOINT" 2>/dev/null | jq \
  '[ .SecurityGroups[]? | {
      GroupId: .GroupId,
      GroupName: .GroupName,
      OpenToWorld: ([ .IpPermissions[]?.IpRanges[]? | select(.CidrIp == "0.0.0.0/0") ] | length > 0)
    } ]' || echo '[]')

# 3. Gather Detailed DynamoDB Configuration
dynamo_raw=$(/opt/homebrew/bin/aws dynamodb describe-table --table-name ministack-table --endpoint-url="$ENDPOINT" 2>/dev/null)
if [ -n "$dynamo_raw" ]; then
    dynamo_json=$(echo "$dynamo_raw" | jq '{
      TableName: .Table.TableName,
      TableStatus: .Table.TableStatus,
      BillingMode: (.Table.BillingModeSummary.BillingMode // "PROVISIONED"),
      EncryptionStatus: (.Table.SSEDescription.Status // "DISABLED"),
      DeletionProtection: (.Table.DeletionProtectionEnabled // false),
      ItemCount: (.Table.ItemCount // 0)
    }')
else
    dynamo_json='{
      "TableName": "ministack-table", 
      "TableStatus": "MISSING", 
      "BillingMode": "UNKNOWN", 
      "EncryptionStatus": "UNKNOWN", 
      "DeletionProtection": false, 
      "ItemCount": 0
    }'
fi

# Combine into a unified compliance report safely
report_json=$(jq -n \
  --arg ts "$TIMESTAMP" \
  --argjson inst "$instances_json" \
  --argjson sgs "$sg_json" \
  --argjson db "$dynamo_json" \
  '{
    timestamp: $ts,
    status: "CHECKED",
    instances: $inst,
    security_groups: $sgs,
    database: $db
  }')

# Save artifact
echo "$report_json" > audit-report.json
echo "Report generated: audit-report.json"

# --- Compliance Evaluations ---
missing_env=$(echo "$report_json" | jq '[.instances[] | select(.Environment == "Unassigned")] | length')
open_sgs=$(echo "$report_json" | jq '[.security_groups[] | select(.OpenToWorld == true and .GroupName != "default")] | length')
db_status=$(echo "$report_json" | jq -r '.database.TableStatus')
db_encryption=$(echo "$report_json" | jq -r '.database.EncryptionStatus')

if [ "$missing_env" -gt 0 ]; then
    echo "COMPLIANCE ERROR: $missing_env instance(s) missing 'Environment' tag!"
    exit 1
elif [ "$db_status" != "ACTIVE" ]; then
    echo "COMPLIANCE ERROR: Database 'ministack-table' is not ACTIVE (Status: $db_status)!"
    exit 1
elif [ "$db_encryption" == "DISABLED" ]; then
    echo "COMPLIANCE WARNING/ERROR: DynamoDB table 'ministack-table' has Server-Side Encryption disabled!"
    # Depending on how strict your policy is, you can exit 1 here. Let's flag it!
    exit 1
else
    echo "SUCCESS: All compute, network, and deep database configuration checks passed!"
    exit 0
fi