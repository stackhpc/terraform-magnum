terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">=1.31.0"
    }
    local = {
      source = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
  }
  required_version = ">= 1.0.0"
  experiments      = [module_variable_optional_attrs]
}
