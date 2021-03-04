clusters = {
  "k8s-sonobuoy-1.20" = {
    template = "k8s-1.20.4"
    labels = {
    }
  }
}

node_count = 2 # Sonobuoy tests require at least 2 nodes

kubeconfig = "k8s-sonobuoy-1.20"
