external_network    = "ilab"
keypair_name        = "alaska"
master_count        = 1
node_count          = 1
fixed_network       = "p3-internal"
fixed_subnet        = "p3-internal"
master_flavor       = "general.v1.tiny"
flavor              = "general.v1.tiny"
floating_ip_enabled = true
master_lb_enabled   = false
volume_driver       = ""
insecure_registry   = "10.60.253.37"
create_timeout      = 60

template_labels = {
  container_infra_prefix  = "10.60.253.37/magnum/"
  monitoring_enabled      = "true"
  auto_scaling_enabled    = "true"
  auto_healing_enabled    = "true"
  auto_healing_controller = "magnum-auto-healer"
  magnum_auto_healer_tag  = "v1.20.0"
  ingress_controller      = "nginx"
}

clusters = {
  "k8s-alaska" = {
    template = "k8s-1.18.15"
    flavor   = "compute-A"
    labels = {
    }
  }
}
kubeconfig = "k8s-alaska"

extra_templates = {
  "k8s-1.18.15" = {
    image = "fedora-coreos-32.20201018.3.0-openstack.x86_64"
    labels = {
      kube_tag           = "v1.18.15-rancher1"
      cloud_provider_tag = "v1.18.0"
    }
  }
  "k8s-1.19.7" = {
    image = "fedora-coreos-32.20201018.3.0-openstack.x86_64"
    labels = {
      kube_tag           = "v1.19.7-rancher1"
      cloud_provider_tag = "v1.19.0"
    }
  }
  "k8s-1.20.2" = {
    image = "fedora-coreos-32.20201018.3.0-openstack.x86_64"
    labels = {
      kube_tag           = "v1.20.2-rancher1"
      cloud_provider_tag = "v1.20.0"
    }
  }
}
