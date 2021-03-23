#!/bin/bash
set -e
LATEST=$(curl -s https://builds.coreos.fedoraproject.org/streams/stable.json | python -c "import json, sys; print(json.loads(sys.stdin.read())['architectures']['x86_64']['artifacts']['openstack']['release'])")
DEFAULT=33.20210301.3.1
DATE=${DATE:-$DEFAULT}
STREAM=${STREAM:-stable}
ARCH=${ARCH:-x86_64}
IMAGE=${IMAGE:-fedora-coreos-$DATE-openstack.$ARCH}
[[ "$DATE" = "$LATEST" ]] && echo "Using the latest image: $IMAGE" || echo "export DATE=$LATEST to upload the latest image because the image you are using is out of date: $IMAGE"
FNAME=$IMAGE.qcow2
openstack image show $IMAGE || (
    [[ -f $FNAME ]] || (
        curl -OL https://builds.coreos.fedoraproject.org/prod/streams/$STREAM/builds/$DATE/$ARCH/$FNAME.xz
        unxz $FNAME.xz
    )
    openstack image create --disk-format=qcow2 --container-format=bare --file=$FNAME --property os_distro='fedora-coreos' $IMAGE
)
sed -i.bak "s/fedora-coreos-.*-openstack.$ARCH/$IMAGE/g" *.tfvars tfvars/*.tfvars *.tf
sed -i.bak "s/$DEFAULT/$DATE/g" $0
