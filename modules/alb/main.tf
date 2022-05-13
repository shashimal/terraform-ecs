resource "aws_alb" "alb" {
  name               = var.name
  internal           = var.is_internet_facing
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = var.security_groups
}

resource "aws_alb_target_group" "alb-tg" {
  for_each = var.target_groups
  name = "${lower(each.value.service_name)}-tg"
  port = each.value.port
  protocol = each.value.protocol
  target_type = "ip"
  vpc_id = var.vpc_id

  health_check {
    path = each.value.health_check.path
    protocol = each.value.protocol
  }
}

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.alb.id
  port = var.listener_port
  protocol = var.listener_protocol

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No routes defined"
      status_code  = "200"
    }
  }
}

resource "aws_alb_listener_rule" "alb-listener-rule" {
  for_each = var.target_groups
  listener_arn = aws_alb_listener.alb-listener.arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alb-tg[each.key].arn
  }
  condition {
    path_pattern {
      values = [each.value.path_pattern]
    }
  }
}