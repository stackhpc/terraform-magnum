templates = {
  "k8s-calico-atomic" = {
    network_driver = "calico"
    image          = "Fedora-AtomicHost-29-20191126.0.x86_64"
    labels = {
      kube_tag           = "v1.15.12"
      cloud_provider_tag = "v1.15.0"
    }
  }
  "k8s-flannel-atomic" = {
    network_driver = "flannel"
    image          = "Fedora-AtomicHost-29-20191126.0.x86_64"
    labels = {
      kube_tag           = "v1.15.12"
      cloud_provider_tag = "v1.15.0"
    }
  }
}

clusters = {
  "k8s-calico-atomic" = {
    template = "k8s-calico-atomic"
  }
  "k8s-flannel-atomic" = {
    template = "k8s-flannel-atomic"
  }
}

kubeconfig = "k8s-calico-atomic"
