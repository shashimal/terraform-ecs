variable "name" {
  type = string
}

variable "internal" {
  type = bool
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "listener_port" {
  type = number
}

variable "listener_protocol" {
  type = string
}

variable "target_groups" {
  type = map(object({
    service_name = string
    port = number
    protocol = string
    path_pattern = string
    health_check = object({
      path: string
    })
  }))
}