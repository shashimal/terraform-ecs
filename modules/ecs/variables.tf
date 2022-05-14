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
    name         = string
    cpu          = number
    memory       = number
    container_port = number
    desired_count = number
    public_service = bool
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
    arn=string
  }))
}

variable "public_alb_target_groups" {
  type = map(object({
    arn=string
  }))
}