clusters = {
  "stein" = {
    network_driver = "calico"
    image          = "Fedora-AtomicHost-29-20191126.0.x86_64"
  }
}

label_overrides = {
  kube_tag                 = "v1.15.12"
  cloud_provider_tag       = "v1.15.0"
  heat_container_agent_tag = "train-stable-3"
}

kubeconfig = "stein"
