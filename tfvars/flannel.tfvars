templates = {
  "k8s-1.18.15" = {
    network_driver = "flannel"
    image          = "fedora-coreos-33.20210117.3.2-openstack.x86_64"
    labels = {
      kube_tag           = "v1.18.15-rancher1"
      cloud_provider_tag = "v1.18.0"
    }
  }
  "k8s-1.19.7" = {
    network_driver = "flannel"
    image          = "fedora-coreos-33.20210117.3.2-openstack.x86_64"
    labels = {
      kube_tag           = "v1.19.7-rancher1"
      cloud_provider_tag = "v1.19.0"
    }
  }
  "k8s-1.20.2" = {
    network_driver = "flannel"
    image          = "fedora-coreos-33.20210117.3.2-openstack.x86_64"
    labels = {
      kube_tag           = "v1.20.2-rancher1"
      cloud_provider_tag = "v1.20.0"
    }
  }
}

clusters = {
  "k8s-1.18" = {
    template = "k8s-1.18.15"
    labels = {
    }
  }
  "k8s-1.19" = {
    template = "k8s-1.19.7"
    labels = {
    }
  }
  "k8s-1.20" = {
    template = "k8s-1.20.2"
    labels = {
    }
  }
}

kubeconfig = "k8s-1.20"
