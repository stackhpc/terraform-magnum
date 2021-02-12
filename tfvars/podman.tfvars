clusters = {
  "k8s-calico-podman" = {
    template = "k8s-calico-atomic"
  }
  "k8s-flannel-podman" = {
    template = "k8s-flannel-atomic"
  }
}

kubeconfig = "k8s-calico-podman"

label_overrides = {
  use_podman = "true"
  etcd_tag   = "v3.4.6"
}
