clusters = {
  "k8s-podman-calico" = "k8s-fedora-atomic-calico"
}

label_overrides = {
  use_podman                            = "true"
  kube_tag                              = "v1.17.3" # https://github.com/kubernetes/kubernetes/releases
  cloud_provider_tag                    = "v1.17.0"
  etcd_tag                              = "3.4.3"
}
