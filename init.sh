#!/bin/bash

# Check for SSH key and create if it doesn't exist
if [ ! -f ~/.ssh/id_rsa_github ]; then
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_github -N ""
fi

# Initialize, plan, and apply Terraform
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
cd ..

# Extract IP address from Terraform output
IP_ADDRESS=$(terraform -chdir=terraform output -raw vm_ip)

# Wait for VM to become SSH accessible
echo "Waiting for IP $IP_ADDRESS to become responsive..."
while ! (nc -zvw3 $IP_ADDRESS 22); do
    sleep 5
done
echo "VM is now responsive."

# Execute Ansible playbook
cd ansible
bash create_hosts.sh
ansible-playbook -i hosts.ini playbook.yml -vvv
cd ..

# Display the application link
echo "Application is available at: http://$IP_ADDRESS"
