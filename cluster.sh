#!/bin/bash
set -x
TFVARS=`basename ${1:-coreos.tfvars}`
TFSTATE=`basename ${2:-terraform.tfstate}`
ACTION=${3:-apply -auto-approve}
pushd `dirname $0`
terraform $ACTION -var-file=tfvars/$TFVARS -state=$TFSTATE
popd
