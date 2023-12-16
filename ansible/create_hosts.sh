#!/bin/bash

# Diretório onde os arquivos do Terraform estão localizados
TERRAFORM_DIR="../terraform"

# Navega para o diretório do Terraform e obtém o output
IP=$(terraform -chdir=$TERRAFORM_DIR output --raw vm_ip)

# Verifica se o IP foi obtido
if [ -z "$IP" ]; then
    echo "Endereço IP não encontrado."
    exit 1
fi

# Diretório onde o arquivo de inventário do Ansible será criado
ANSIBLE_DIR="."

# Cria o arquivo de inventário
cat << EOF > "$ANSIBLE_DIR/hosts.ini"
[webservers]
$IP

[webservers:vars]
ansible_ssh_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_rsa_github
EOF

echo "Arquivo de inventário criado em $ANSIBLE_DIR/hosts.ini"

