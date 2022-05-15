variable "app_name" {
  type = string
}

variable "app_services" {
  type = list(string)
}

variable "account" {
  type = number
}

variable "region" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "service_config" {
  type = map(object({
    name           = string
    is_public      = bool
    container_port = number
    host_port      = number
    cpu            = number
    memory         = number
    desired_count  = number

    alb_target_group = object({
      port              = number
      protocol          = string
      path_pattern      = list(string)
      health_check_path = string
      priority          = number
    })

    auto_scaling = object({
      max_capacity = number
      min_capacity = number
      cpu          = object({
        target_value = number
      })
      memory = object({
        target_value = number
      })
    })
  }))
}

variable "internal_alb_security_group" {
  type = any
}

variable "public_alb_security_group" {
  type = any
}

variable "internal_alb_target_groups" {
  type = map(object({
    arn = string
  }))
}

variable "public_alb_target_groups" {
  type = map(object({
    arn = string
  }))
}