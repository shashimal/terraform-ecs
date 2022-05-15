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

variable "listeners" {
  type = map(object({
    listener_port = number
    listener_protocol = string
  }))
}

variable "listener_port" {
  type = number
}

variable "listener_protocol" {
  type = string
}

variable "target_groups" {
  type = map(object({
    port              = number
    protocol          = string
    path_pattern      = list(string)
    health_check_path = string
    priority          = number
  }))
}