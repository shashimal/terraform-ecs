variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "vpc-id" {
  type = string
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    cidr_blocks = list(string)
    protocol    = string
  }))
}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    cidr_blocks = list(string)
    protocol    = string
  }))
}
