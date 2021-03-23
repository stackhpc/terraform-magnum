#!/bin/bash
set -x
while openstack coe cluster delete `openstack coe cluster list -c uuid -f value`
do
	sleep 5
done
openstack coe cluster template delete `openstack coe cluster template list -c uuid -f value`
