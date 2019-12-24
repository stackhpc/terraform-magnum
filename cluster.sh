#!/bin/bash
set -x
CLUSTER=${CLUSTER:-coreos}
ACTION=${ACTION:-apply}
pushd terraform/
terraform $ACTION -var-file=$CLUSTER.tfvars -auto-approve
popd
