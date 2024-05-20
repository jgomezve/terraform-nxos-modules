terraform {
  required_version = ">= 1.6.0"
  required_providers {
    nxos = {
      source  = "CiscoDevNet/nxos"
      version = ">=0.5.2"
    }
  }
}