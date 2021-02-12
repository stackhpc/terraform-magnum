clusters = {
  "k8s-calico-podman" = {
    template = "k8s-calico-atomic"
    labels = {
      use_podman = "true"
      etcd_tag   = "v3.4.6"
    }
  }
  "k8s-flannel-podman" = {
    template = "k8s-flannel-atomic"
    labels = {
      use_podman = "true"
      etcd_tag   = "v3.4.6"
    }
  }
}

kubeconfig = "k8s-calico-podman"
