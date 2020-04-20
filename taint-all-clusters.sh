#!/bin/bash
for i in `terraform state list | grep _cluster_`; do terraform taint $i; done
