variable "instances" {
  type = map(object({
    instance_type = string
    subnet_id   = string
    ami           = string
    key_id      = string
  }))
  description = "Map of instance names to their configurations"
}