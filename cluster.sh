#!/bin/bash
set -x
CLUSTER=${1:-coreos}
ACTION=${2:-apply}
pushd `dirname $0`
terraform $ACTION -var-file=$CLUSTER.tfvars -auto-approve
popd
