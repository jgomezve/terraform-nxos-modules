terraform {
  required_providers {
    nxos = {
      source = "CiscoDevNet/nxos"
    }
  }
}


provider "nxos" {
  username = "cisco"
  password = "cisco"
  devices = [
    {
      url  = "https://10.1.17.22"
      name = "SW1"
    },
    {
      url  = "https://10.1.17.23"
      name = "SW2"
    }
  ]
}

resource "nxos_bridge_domain" "vlan-test" {
  for_each     = toset(["SW1", "SW2"])
  fabric_encap = "vlan-10"
  name         = "VLAN-TEST"
  device       = each.value
}