variable "devices" {
  type = list(object({
    url  = string
    name = string
  }))

  default = [
    {
      url  = "https://10.122.18.82"
      name = "SW1"
    },
    {
      url  = "https://10.122.18.88"
      name = "SW2"
    }
  ]
}