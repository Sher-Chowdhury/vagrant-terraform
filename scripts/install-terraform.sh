#!/bin/bash

echo '##########################################################################'
echo '########### About to run install-terraform.sh script #####################'
echo '##########################################################################'

mkdir /usr/bin/terraform || exit 1
cd /usr/bin/terraform || exit 1
wget https://releases.hashicorp.com/terraform/0.7.3/terraform_0.7.3_linux_amd64.zip || exit 1
unzip terraform_0.7.3_linux_amd64.zip || exit 1
rm terraform_0.7.3_linux_amd64.zip || exit 1 
