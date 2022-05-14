resource "aws_security_group" "security_group" {
  name        = var.name
  vpc_id      = var.vpc_id
  description = var.description

  dynamic "ingress" {
    for_each = toset(var.ingress_rules)
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      cidr_blocks = ingress.value.cidr_blocks
      protocol    = ingress.value.protocol
    }
  }

  dynamic "egress" {
    for_each = toset(var.egress_rules)
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      cidr_blocks = egress.value.cidr_blocks
      protocol    = egress.value.protocol
    }
  }
}