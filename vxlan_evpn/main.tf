terraform {
  required_version = ">= 1.1.0"

  required_providers {
    nxos = {
      source  = "CiscoDevNet/nxos"
      version = ">= 0.5.0"
    }
  }
}

provider "nxos" {
  username = "cisco"
  password = "cisco"
  devices = [
    {
      url  = "https://10.1.17.25"
      name = "SPINE-1"
    },
    {
      url  = "https://10.1.17.24"
      name = "SPINE-2"
    },
    {
      url  = "https://10.1.17.23"
      name = "LEAF-1"
    },
    {
      url  = "https://10.1.17.22"
      name = "LEAF-2"
    }
  ]
}

module "nxos_evpn_ospf_underlay" {
  source  = "netascode/evpn-ospf-underlay/nxos"
  version = ">= 0.2.0"

  leafs           = ["LEAF-1", "LEAF-2"]
  spines          = ["SPINE-1", "SPINE-2"]
  loopback_id     = 0
  pim_loopback_id = 100

  loopbacks = [
    {
      device       = "SPINE-1",
      ipv4_address = "10.1.100.1"
    },
    {
      device       = "SPINE-2",
      ipv4_address = "10.1.100.2"
    },
    {
      device       = "LEAF-1",
      ipv4_address = "10.1.100.3"
    },
    {
      device       = "LEAF-2",
      ipv4_address = "10.1.100.4"
    }
  ]

  vtep_loopback_id = 1

  vtep_loopbacks = [
    {
      device       = "LEAF-1",
      ipv4_address = "10.1.200.1"
    },
    {
      device       = "LEAF-2",
      ipv4_address = "10.1.200.2"
    }
  ]

  leaf_fabric_interface_prefix  = "1/"
  leaf_fabric_interface_offset  = "1"
  spine_fabric_interface_prefix = "1/"
  spine_fabric_interface_offset = "1"
  anycast_rp_ipv4_address       = "10.1.101.1"
}


module "nxos_evpn_overlay" {
  source  = "netascode/evpn-overlay/nxos"
  version = ">= 0.3.0"

  leafs                = ["LEAF-1", "LEAF-2"]
  spines               = ["SPINE-1", "SPINE-2"]
  underlay_loopback_id = 0

  underlay_loopbacks = [
    {
      device       = "SPINE-1",
      ipv4_address = "10.1.100.1"
    },
    {
      device       = "SPINE-2",
      ipv4_address = "10.1.100.2"
    },
    {
      device       = "LEAF-1",
      ipv4_address = "10.1.100.3"
    },
    {
      device       = "LEAF-2",
      ipv4_address = "10.1.100.4"
    }
  ]

  vtep_loopback_id = 1
  bgp_asn          = 65000

  l3_services = [
    {
      name = "GREEN"
      id   = 1000
    },
    {
      name = "BLUE"
      id   = 1010
    }
  ]

  l2_services = [
    {
      name                 = "L2_101"
      id                   = 101
      ipv4_multicast_group = "225.0.0.101"
    },
    {
      name = "L2_102"
      id   = 102
    },
    {
      name                 = "GREEN_1001"
      id                   = 1001
      ipv4_multicast_group = "225.0.1.1"
      l3_service           = "GREEN"
      ipv4_address         = "172.16.1.1/24"
    },
    {
      name         = "BLUE_1011"
      id           = 1011
      l3_service   = "BLUE"
      ipv4_address = "172.17.1.1/24"
    }
  ]

  depends_on = [module.nxos_evpn_ospf_underlay]

}