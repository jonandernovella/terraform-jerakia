#!/bin/bash
set -e

if [ ! -f ./terraform.tfvars ]; then
    echo "Please create terraform.tfvars" >&2
    exit 1
fi

terraform init 
terraform plan > ./tf-plan
terraform apply
terraform output -module=etcd_node inventory > ./etcd-inventory