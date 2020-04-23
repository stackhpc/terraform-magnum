#!/bin/bash
set -x
TFSTATE=`basename ${1:-terraform.tfstate}`
for i in `terraform state list -state=$TFSTATE | grep _cluster_`; do terraform taint -state=$TFSTATE $i; done
