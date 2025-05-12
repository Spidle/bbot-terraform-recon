# BBOT Terraform Recon

This project automates subdomain reconnaissance using [BBOT](https://github.com/blacklanternsecurity/bbot), deployed temporarily on a DigitalOcean VPS using Terraform and Ansible.

## Features

- Deploys a DigitalOcean droplet from a snapshot with BBOT pre-installed
- Runs BBOT against one or more target domains
- Saves the output in JSONL format for use with the Elastic Stack
- Tears down the droplet after scan completion

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- DigitalOcean account and access token
- SSH key added to DigitalOcean

## Setup

1. Clone the repo
2. Create a file `terraform.tfvars`:

```hcl
   do_token         = "your_digitalocean_token"
   ssh_fingerprint  = "your_ssh_key_fingerprint"
```
3. Create a droplet in DigitalOcean. Install BBOT and test to make sure it's working. Ge the snapshot ID and replace it in main.tf image =

Get the snapshot ID Digital Ocean CLI
```
doctl compute image list-user | grep bbot-base
```
## Usage

`./run.sh "example.com test.com" "my-scan-id"`

- The first argument is a space-separated list of target domains.
- The second argument is an identifier used to name the result folder under results/.

## Output

BBOT output is saved to:

results/<scan-id>/bbot_output.jsonl

## Notes
- inventory.ini is dynamically created by the script.
- Results are pulled via scp before the droplet is destroyed.
- Make sure your SSH key allows root login on the snapshot.

## Cleanup

To clean up all resources (in case of failure or early exit):
```
terraform destroy -auto-approve
```
