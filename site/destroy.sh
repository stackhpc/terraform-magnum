#!/bin/bash
set -x
`dirname $0`/cluster.sh "$1" "$2" "destroy"
