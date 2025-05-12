#!/bin/bash

TARGET_DOMAINS="$1"
SCAN_ID="$2"

if [ -z "$TARGET_DOMAINS" ] || [ -z "$SCAN_ID" ]; then
  echo "Usage: $0 \"example.com test.com\" \"scan_id\""
  exit 1
fi

terraform init
terraform apply -auto-approve -var-file="terraform.tfvars"

IP=$(terraform output -raw droplet_ip)

echo "[bbot]" > inventory.ini
echo "$IP ansible_user=root" >> inventory.ini

# Wait for SSH
echo "[*] Waiting for 75s for SSH on $IP..."
sleep 75

# Run BBOT using Ansible
echo "[*] Running Ansible playbook..."
ansible-playbook -i inventory.ini playbook.yml --extra-vars "target_domains=${TARGET_DOMAINS}"

# Make local results folder
mkdir -p "results/${SCAN_ID}"

# Copy results from droplet to local folder
scp -r -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    root@$IP:/prod_bbot_scan/ "results/${SCAN_ID}/"

# Tear down droplet
terraform destroy -auto-approve
echo "[*] Droplet destroyed."
echo "[*] Results saved in results/${SCAN_ID}/"
echo "[*] Done."