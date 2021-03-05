#!/bin/bash
set -x
`dirname $0`/create.sh "$1" "$2" "destroy -auto-approve"
