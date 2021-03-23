#!/bin/bash
set -x
DIR=`dirname $0`/..
TFDIR=`realpath $DIR`
TFVARS=${1:-$TFDIR/tfvars/coreos.tfvars}
TFSTATE=${2:-$TFDIR/terraform.tfstate}
ACTION=${3:-plan}
terraform $ACTION -var-file=$TFVARS -state=$TFSTATE
