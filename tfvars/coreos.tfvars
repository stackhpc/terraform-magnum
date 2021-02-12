clusters = {
  "k8s-calico-coreos" = {
    template = "k8s-calico-coreos"
    label_overrides = {
    }
  }
  "k8s-flannel-coreos" = {
    template = "k8s-flannel-coreos"
    label_overrides = {
    }
  }
}

kubeconfig = "k8s-calico-coreos"

labels = {
  "kube_tag"           = "v1.20.2-rancher1"
  "cloud_provider_tag" = "v1.20.0"
}
