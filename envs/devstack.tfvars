node_count          = 2
external_network    = "public"
keypair_name        = "devstack"
floating_ip_enabled = "true"
master_lb_enabled   = "false"
cluster_labels = {
  container_infra_prefix = "ghcr.io/stackhpc/"
}

clusters = {
  "k8s-devstack" = {
    template          = "k8s-1.21.0"
    fixed_network     = "private"
    fixed_subnet      = "private-subnet"
    labels = {
      container_runtime = "containerd"
      fixed_ipv6_subnet      = "ipv6-private-subnet"
    }
  }
}

kubeconfig = "k8s-devstack"
