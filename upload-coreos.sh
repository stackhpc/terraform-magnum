#!/bin/bash
set -ex
DATE=${DATE:-`curl https://builds.coreos.fedoraproject.org/streams/stable.json | jq -r '.architectures.x86_64.artifacts.openstack.release'`}
STREAM=${STREAM:-stable}
ARCH=${ARCH:-x86_64}
IMAGE=${IMAGE:-fedora-coreos-$DATE-openstack.$ARCH}
FNAME=$IMAGE.qcow2
sed -i "s/fedora-coreos-.*-openstack.$ARCH/$IMAGE/g" *.tfvars
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
