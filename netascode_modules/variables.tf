variable "devices" {
  type = list(object({
    url  = string
    name = string
  }))

  default = [
    {
      url  = "https://10.0.0.1"
      name = "SW1"
    },
    {
      url  = "https://10.0.0.2"
      name = "SW2"
    }
  ]
}