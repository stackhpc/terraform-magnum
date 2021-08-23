external_network    = "ilab"
keypair_name        = "alaska"
master_count        = 1
node_count          = 2
fixed_network       = "p3-internal"
fixed_subnet        = "p3-internal"
master_flavor       = "general.v1.tiny"
flavor              = "general.v1.tiny"
floating_ip_enabled = true
master_lb_enabled   = false
volume_driver       = ""
create_timeout      = 60

template_labels = {
  container_infra_prefix = "harbor.cumulus.openstack.hpc.cam.ac.uk/magnum/"
  monitoring_enabled     = "true"
  auto_scaling_enabled   = "false"
  auto_healing_enabled   = "false"
}

clusters = {
  "k8s-alaska" = {
    template = "k8s-1.21.2"
    labels = {
      selinux_mode = "permissive"
    }
  }
}
kubeconfig = "k8s-alaska"

image = "fedora-coreos-32.20200601.3.0-openstack.x86_64"
