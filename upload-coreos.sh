#!/bin/bash
DATE=30.20191014.1
IMAGE=${IMAGE:-fedora-coreos-$DATE-openstack}
ARCH=${ARCH:-x86_64}
FNAME=$IMAGE.$ARCH.qcow2
if [ ! -f $FNAME ]; then
    curl -OL https://builds.coreos.fedoraproject.org/prod/streams/testing/builds/$DATE/$ARCH/$FNAME.xz
    unxz $FNAME.xz
fi
openstack image create \
    --disk-format=qcow2 \
    --container-format=bare \
    --file=$FNAME \
    --property os_distro='fedora-coreos' \
    $IMAGE

