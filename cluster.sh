#!/bin/bash
set -x
TFVARS=${1:-coreos}
ACTION=${2:-apply}
pushd `dirname $0`
terraform $ACTION -var-file=$TFVARS -auto-approve
popd
