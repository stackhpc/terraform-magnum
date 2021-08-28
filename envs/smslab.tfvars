node_count       = 2
external_network = "stackhpc-ipv4-vlan-magnum"
keypair_name     = "smslab"
master_flavor    = "general.v1.tiny"
flavor           = "general.v1.tiny"

cluster_labels = {
  container_infra_prefix = "ghcr.io/stackhpc/"
}

clusters = {
  "k8s-smslab" = {
    template            = "k8s-1.21.2"
    floating_ip_enabled = "true"
    flavor           = "general.v1.small"
    labels = {
      etcd_volume_size = 1
      monitoring_enabled = "false"
      auto_healing_enabled = "false"
      auto_scaling_enabled = "false"
    }
  }
}

kubeconfig = "k8s-smslab"

bastion = {
  count        = 1
  name         = "clusterctl"
  network      = "stackhpc-ipv4-vlan-magnum"
  image        = "34a622a7-703e-4d43-b116-6fe92f04de14" # Ubuntu-20.04
  flavor       = "abf8401b-f0f4-4c20-bdfa-5626bca8bf31" # general.v1.tiny
  keypair_name = "smslab"
  bastion_host = "185.45.78.150"
  bastion_user = "bharat"
  user         = "ubuntu"
}
