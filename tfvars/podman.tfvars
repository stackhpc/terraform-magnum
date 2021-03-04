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
