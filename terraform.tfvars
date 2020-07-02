master_count        = 3
max_node_count      = 16
flavor_name         = "m1.xlarge"
master_flavor_name  = "m1.large"
image_name          = "Fedora-AtomicHost-29-20191126.0"
fixed_network_name  = "radarad-vxlan"
fixed_subnet_id     = "3796a86e-b8cb-4da5-a004-d1613533d79e"
external_network_id = "275ec9cd-a51e-4747-a2c4-23bb72d1cc06"
keypair_name        = "radarad"
public_key_file     = "~/.ssh/id_rsa.pub"
master_fip_enabled  = "true"
fip_enabled         = "false"
volume_driver       = "cinder"
kube_tag            = "v1.17.2"
cloud_provider_tag  = "v1.17.0"
etcd_volume_size    = 10
kubelet_options     = "--eviction-hard=memory.available<1.5G --system-reserved=memory=1Gi --housekeeping-interval=10s --eviction-soft=memory.available<2G --eviction-soft-grace-period=memory.available=30s --eviction-max-pod-grace-period=10"
hca_tag             = "train-stable-3"
