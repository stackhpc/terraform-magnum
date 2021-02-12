#!/bin/bash
set -x
TFDIR=`dirname $0`
TFSTATE=$PWD/${1:-$TFDIR/terraform.tfstate}
for i in `terraform state list -state=$TFSTATE | grep _cluster_`; do terraform taint -state=$TFSTATE $i; done
