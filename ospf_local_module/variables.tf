variable "devices" {
  type = list(object({
    url  = string
    name = string
  }))

  default = [
    {
      url  = "https://198.18.1.11"
      name = "SPINE-1"
    },
    {
      url  = "https://198.18.1.12"
      name = "SPINE2-2"
    }
  ]
}