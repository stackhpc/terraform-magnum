variable "bastion" {
  type = map(any)
}

data "openstack_networking_network_v2" "bastion" {
  count = lookup(var.bastion, "count", 0)
  name  = var.bastion.network
}

resource "openstack_networking_port_v2" "bastion" {
  count          = lookup(var.bastion, "count", 0)
  name           = var.bastion.name
  network_id     = data.openstack_networking_network_v2.bastion[count.index].id
  admin_state_up = "true"
}

resource "openstack_compute_instance_v2" "bastion" {
  count           = lookup(var.bastion, "count", 0)
  name            = var.bastion.name
  image_id        = var.bastion.image
  flavor_id       = var.bastion.flavor
  key_pair        = var.bastion.keypair_name
  security_groups = ["default"]

  network {
    port = openstack_networking_port_v2.bastion[count.index].id
  }

}

resource "null_resource" "bastion" {
  count = lookup(var.bastion, "count", 0)
  triggers = {
    host       = openstack_compute_instance_v2.bastion[count.index].access_ip_v4
    packages   = "helm kubectl clusterctl sonobuoy"
    kubeconfig = file(pathexpand("~/.kube/config"))
  }

  connection {
    type         = "ssh"
    host         = self.triggers.host
    user         = var.bastion.user
    bastion_host = var.bastion.bastion_host
    bastion_user = var.bastion.bastion_user
  }

  provisioner "file" {
    content     = self.triggers.kubeconfig
    destination = "/tmp/config"
  }

  provisioner "remote-exec" {
    inline = [
      "git clone --depth 1 https://github.com/stackhpc/terraform-magnum",
      "cd terraform-magnum",
      "make ${self.triggers.packages}",
      "mkdir -p ~/.kube; mv /tmp/config ~/.kube/config; chmod 600 ~/.kube/config",
    ]
  }
  depends_on = [null_resource.kubeconfig]
}

output "bastion" {
  value = openstack_compute_instance_v2.bastion[*].access_ip_v4
}
