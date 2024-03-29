node_count       = 2
external_network = "public"
keypair_name     = "devstack"

cluster_labels = {
  container_infra_prefix = "ghcr.io/stackhpc/"
}

clusters = {
  "k8s-devstack" = {
    template            = "k8s-1.21.2"
    floating_ip_enabled = "true"
    labels = {
    }
  }
}

kubeconfig = "k8s-devstack"
