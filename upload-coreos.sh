#!/bin/bash
set -x
DATE=${DATE:-31.20191210.3.0}
STREAM=${STREAM:-stable}
IMAGE=${IMAGE:-fedora-coreos-$DATE-openstack}
ARCH=${ARCH:-x86_64}
FNAME=$IMAGE.$ARCH.qcow2
if [ ! -f $FNAME ]; then
    curl -OL https://builds.coreos.fedoraproject.org/prod/streams/$STREAM/builds/$DATE/$ARCH/$FNAME.xz
    unxz $FNAME.xz
fi
openstack image create \
    --disk-format=qcow2 \
    --container-format=bare \
    --file=$FNAME \
    --property os_distro='fedora-coreos' \
    $IMAGE

