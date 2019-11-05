#!/bin/bash
IMAGE=${IMAGE:-20191028.0}
ARCH=${ARCH:-x86_64}
curl -OL https://ftp.icm.edu.pl/pub/Linux/dist/fedora-alt/atomic/stable/Fedora-29-updates-${IMAGE}/AtomicHost/${ARCH}/images/Fedora-AtomicHost-29-${IMAGE}.${ARCH}.qcow2
openstack image create \
     --disk-format=qcow2 \
     --container-format=bare \
     --file=Fedora-AtomicHost-29-${IMAGE}.${ARCH}.qcow2\
     --property os_distro='fedora-atomic' \
     FedoraAtomic29-$IMAGE
