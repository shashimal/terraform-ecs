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
variable "internal_alb_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    cidr_blocks = list(string)
    protocol    = string
  }))
}

variable "internal_alb_egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    cidr_blocks = list(string)
    protocol    = string
  }))
}

variable "public_alb_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    cidr_blocks = list(string)
    protocol    = string
  }))
}

variable "public_alb_egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    cidr_blocks = list(string)
    protocol    = string
  }))
}

variable "internal_alb_target_groups" {
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

variable "public_alb_target_groups" {
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
variable "service_config" {
  type = map(object({
    name          = string
    cpu           = number
    memory        = number
    container_port = number
    desired_count = number
    public_service = bool
  }))
}
########################################################################################################################