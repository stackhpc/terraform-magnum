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

label_overrides = {
  use_podman                            = "true"
  kube_tag                              = "v1.17.3" # https://github.com/kubernetes/kubernetes/releases
  cloud_provider_tag                    = "v1.17.0"
  etcd_tag                              = "3.4.3"
}
