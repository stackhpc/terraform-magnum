#!/bin/bash
set -x
CLUSTER=${CLUSTER:-coreos}
pushd terraform/
while true; do
    terraform apply -var-file=$CLUSTER.tfvars -auto-approve || terraform destroy -var-file=$CLUSTER.tfvars -auto-approve
    sleep 5
done
popd
