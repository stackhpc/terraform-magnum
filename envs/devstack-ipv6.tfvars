node_count       = 2
external_network = "public"
keypair_name     = "devstack"

cluster_labels = {
  container_infra_prefix = "ghcr.io/stackhpc/"
}

clusters = {
  "k8s-ipv6" = {
    template            = "k8s-1.21.2"
    fixed_network       = "private"
    fixed_subnet        = "private-subnet"
    labels = {
      fixed_ipv6_subnet = "ipv6-private-subnet"
      container_runtime = "containerd"
    }
  }
}

kubeconfig = "k8s-ipv6"
