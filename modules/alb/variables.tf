variable "app_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "target-groups" {
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