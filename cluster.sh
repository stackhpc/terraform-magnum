#!/bin/bash
set -x
TFVARS=${1:-coreos.tfvars}
TFSTATE=${2:-terraform.tfstate}
ACTION=${3:-apply -auto-approve}
pushd `dirname $0`
terraform $ACTION -var-file=$TFVARS -state=$TFSTATE
popd
