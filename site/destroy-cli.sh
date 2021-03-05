#!/bin/bash
set -x
openstack coe cluster delete `openstack coe cluster list -c uuid -f value`
openstack coe cluster template delete `openstack coe cluster template list -c uuid -f value`
