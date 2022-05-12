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

variable "ecs-task-execution-role-arn" {
  type = string
}

variable "task_definition_config" {
  type = map(object({
    name         = string
    cpu          = number
    memory       = number
    containerPort = number
  }))
}