clusters = {
  "k8s-calico-podman" = {
    network_driver = "calico"
    image          = "Fedora-AtomicHost-29-20191126.0.x86_64"
  }
  "k8s-flannel-podman" = {
    network_driver = "flannel"
    image          = "Fedora-AtomicHost-29-20191126.0.x86_64"
  }
}

kubeconfig = "k8s-calico-podman"

label_overrides = {
  use_podman         = "true"
  etcd_tag           = "v3.4.6"
}
