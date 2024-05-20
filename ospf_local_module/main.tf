terraform {
  required_version = ">= 1.6.0"
  required_providers {
    nxos = {
      source  = "CiscoDevNet/nxos"
      version = ">=0.5.2"
    }
  }
}

provider "nxos" {
  username = "admin"
  password = "C1sco12345"
  devices  = var.devices  #fsdf
}


resource "nxos_feature_ospf" "feature_ospf" {
  for_each    = { for dev in var.devices : dev.name => dev }
  admin_state = "enabled"
  device      = each.value.name
}

resource "nxos_ospf" "ospf_entity" {
  for_each    = { for dev in var.devices : dev.name => dev }
  admin_state = "enabled"
  device      = each.value.name
  depends_on  = [nxos_feature_ospf.feature_ospf]
}

module "ospf_a" {
  for_each = { for dev in var.devices : dev.name => dev }

  source = "./modules/ospf"

  name      = "OSPFA"
  router_id = "1.1.1.1"
  interfaces = [{
    id   = "eth1/10"
    area = "0.0.0.0"
  }]
  device     = each.value.name
  depends_on = [nxos_ospf.ospf_entity]

}

module "ospf_b" {

  source = "./modules/ospf"

  name      = "OSPFB"
  router_id = "2.2.2.2"
  interfaces = [{
    id   = "eth1/11"
    area = "0.0.0.0"
  }]
  device     = "SW1"
  depends_on = [nxos_ospf.ospf_entity]

}