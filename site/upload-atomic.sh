#!/bin/bash
set -ex
DATE=${1:-20191126.0}
ARCH=${ARCH:-x86_64}
IMAGE=${IMAGE:-Fedora-AtomicHost-29-$DATE.$ARCH}
FNAME=$IMAGE.qcow2
set -e
openstack image show $IMAGE || (
    curl -OL https://dl.fedoraproject.org/pub/alt/atomic/stable/Fedora-29-updates-$DATE/AtomicHost/$ARCH/images/$FNAME
    openstack image create \
         --disk-format=qcow2 \
         --container-format=bare \
         --file=$FNAME \
         --property os_distro=fedora-atomic --property hw_rng_model=virtio \
         $IMAGE
    )
