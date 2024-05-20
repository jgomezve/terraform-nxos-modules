variable "name" {
  type = string
}

variable "vrf" {
  type    = string
  default = "default"
}

variable "router_id" {
  type = string
}

variable "interfaces" {
  type = list(object({
    id   = string
    area = string
  }))
}

variable "device" {
  type = string
}