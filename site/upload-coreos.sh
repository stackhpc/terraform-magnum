#!/bin/bash
set -e
LATEST=$(curl -s https://builds.coreos.fedoraproject.org/streams/stable.json | python3 -c "import json, sys; print(json.loads(sys.stdin.read())['architectures']['x86_64']['artifacts']['openstack']['release'])")
DEFAULT=34.20210529.3.0
DATE=${DATE:-$DEFAULT}
STREAM=${STREAM:-stable}
ARCH=${ARCH:-x86_64}
USELATEST="y"
[[ "$DATE" = "$LATEST" ]] || read -p "The image you are using is $DATE but the latest is $LATEST. Use latest? [Y/n] " USELATEST
[[ "$(echo $USELATEST | tr '[:upper:]' '[:lower:]')" = "n" ]] || DATE=$LATEST
IMAGE=${IMAGE:-fedora-coreos-$DATE-openstack.$ARCH}
echo "Using image: $IMAGE"
FNAME=$IMAGE.qcow2
set -x
openstack image show $IMAGE || (
    [[ -f "$FNAME" ]] || (
        curl -OL https://builds.coreos.fedoraproject.org/prod/streams/$STREAM/builds/$DATE/$ARCH/$FNAME.xz
        unxz $FNAME.xz
    )
    openstack image create --disk-format=qcow2 --container-format=bare --file=$FNAME --property os_distro='fedora-coreos' $IMAGE
)
sed -i.bak "s/fedora-coreos-.*-openstack.$ARCH/$IMAGE/g" *.tfvars tfvars/*.tfvars *.tf
sed -i.bak "s/$DEFAULT/$DATE/g" $0
