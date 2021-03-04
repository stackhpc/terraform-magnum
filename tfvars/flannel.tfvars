network_driver = "flannel"

clusters = {
  "k8s-flannel-1.18" = {
    template = "k8s-1.18.16"
    labels = {
    }
  }
  "k8s-flannel-1.19" = {
    template = "k8s-1.19.8"
    labels = {
    }
  }
  "k8s-flannel-1.20" = {
    template = "k8s-1.20.3"
    labels = {
    }
  }
}

kubeconfig = "k8s-flannel-1.20"
