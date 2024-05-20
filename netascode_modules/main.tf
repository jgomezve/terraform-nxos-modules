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
  username = "cisco"
  password = "cisco"
  devices  = var.devices
}


resource "nxos_feature_ospf" "feature_ospf" {
  admin_state = "enabled"
}

resource "nxos_ospf" "ospf_entity" {
  admin_state = "enabled"
  depends_on  = [nxos_feature_ospf.feature_ospf]
}

resource "nxos_physical_interface" "test_iface" {
  interface_id = "eth1/20"
  layer        = "Layer3"
}

module "nxos_ospf" {
  source  = "netascode/ospf/nxos"
  version = ">= 0.2.0"

  name = "OSPFC"
  vrfs = [
    {
      vrf                      = "default"
      admin_state              = false
      bandwidth_reference      = 1000
      bandwidth_reference_unit = "gbps"
      distance                 = 120
      router_id                = "100.1.1.1"
      areas = [
        {
          area = "0.0.0.0"
        },
        {
          area                = "10.0.0.0"
          authentication_type = "md5"
          cost                = 100
          type                = "nssa"
        }
      ]
      interfaces = [
        {
          interface             = "eth1/20"
          area                  = "10.0.0.0"
          advertise_secondaries = false
          bfd                   = "enabled"
          cost                  = 1000
          dead_interval         = 60
          hello_interval        = 20
          network_type          = "p2p"
          passive               = "enabled"
          authentication_key    = "0 foo"
          authentication_key_id = 12
          authentication_type   = "simple"
          priority              = 100
        },
        {
          interface = "vlan10"
        }
      ]
    }
  ]
  depends_on = [nxos_physical_interface.test_iface, nxos_ospf.ospf_entity, module.nxos_interface_vlan]
}


module "nxos_interface_vlan" {
  source = "git@github.com:netascode/terraform-nxos-interface-vlan.git?ref=main"

  id           = 10
  admin_state  = true
  ipv4_address = "3.1.1.1/24"
  ipv4_secondary_addresses = [
    "2.1.2.1/24",
    "2.1.3.1/24"
  ]
  description = "Terraform was here"
  mtu         = 9216
}