clusters = {
  "k8s-calico-sonobuoy" = {
    template = "k8s-calico-coreos"
  }
  "k8s-flannel-sonobuoy" = {
    template = "k8s-flannel-coreos"
  }
}

node_count = 2
kubeconfig = "k8s-calico-sonobuoy"
