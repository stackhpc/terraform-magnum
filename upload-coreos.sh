#!/bin/bash
set -x
DATE=${DATE:-31.20200310.3.0}
STREAM=${STREAM:-stable}
ARCH=${ARCH:-x86_64}
IMAGE=${IMAGE:-fedora-coreos-$DATE-openstack.$ARCH}
FNAME=$IMAGE.qcow2
set +x
LATEST=`curl https://builds.coreos.fedoraproject.org/streams/stable.json | jq -r '.architectures.x86_64.artifacts.openstack.release'`
echo
if [[ $DATE != $LATEST ]]; then
	echo "$IMAGE may be an out of date release. DATE=$LATEST is the latest."
else
	echo "$IMAGE is the latest stable release."
fi
set -e
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
