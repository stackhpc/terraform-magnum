#!/bin/bash
set -x
DATE=${DATE:-20191126.0}
IMAGE=${IMAGE:-Fedora-AtomicHost-29-$DATE}
ARCH=${ARCH:-x86_64}
FNAME=$IMAGE.$ARCH.qcow2
if [ ! -f $FNAME ]; then
    curl -OL https://dl.fedoraproject.org/pub/alt/atomic/stable/Fedora-29-updates-$DATE/AtomicHost/$ARCH/images/$FNAME
fi
openstack image create \
     --disk-format=qcow2 \
     --container-format=bare \
     --file=$FNAME \
     --property os_distro=fedora-atomic --property hw_rng_model=virtio \
     $IMAGE
