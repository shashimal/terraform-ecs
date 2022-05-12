########################################################################################################################

# Application
variable "account" {
  type = number
}

variable "region" {
  type = string
}

variable "app_name" {
  type = string
}

variable "app_services" {
  type = list(string)
}

variable "env" {
  type = string
}
########################################################################################################################

# VPC
variable "cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}
########################################################################################################################

#ALB
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
########################################################################################################################

#ECS
variable "task_definition_config" {
  type = map(object({
    name          = string
    cpu           = number
    memory        = number
    containerPort = number
  }))
}
########################################################################################################################
