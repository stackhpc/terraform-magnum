#!/bin/bash
set -x
TFDIR=`dirname $0`
TFVARS=$PWD/${1:-$TFDIR/coreos.tfvars}
TFSTATE=$PWD/${2:-$TFDIR/terraform.tfstate}
ACTION=${3:-apply -auto-approve}
pushd $TFDIR
terraform $ACTION -state=$TFSTATE -var-file=$TFVARS
popd
