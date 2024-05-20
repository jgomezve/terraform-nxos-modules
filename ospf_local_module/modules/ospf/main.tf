resource "nxos_ospf_instance" "ospfInst" {
  name   = var.name
  device = var.device
}

resource "nxos_ospf_vrf" "ospfDom" {
  instance_name = var.name
  name          = var.vrf
  router_id     = var.router_id
  device        = var.device

  depends_on = [
    nxos_ospf_instance.ospfInst
  ]
}

resource "nxos_ospf_interface" "ospfIf" {
  for_each      = { for iface in var.interfaces : iface.id => iface }
  instance_name = var.name
  vrf_name      = var.vrf
  interface_id  = each.value.id
  area          = each.value.area
  device        = var.device

  depends_on = [
    nxos_ospf_vrf.ospfDom,
    nxos_physical_interface.l1PhysIf
  ]
}

resource "nxos_physical_interface" "l1PhysIf" {
  for_each     = { for iface in var.interfaces : iface.id => iface }
  interface_id = each.value.id
  admin_state  = "up"
  layer        = "Layer3"
  device       = var.device
}