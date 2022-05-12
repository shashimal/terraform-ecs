resource "aws_alb" "ecs-internal-alb" {
  name               = "${lower(var.app_name)}-ecs-internal-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.private_subnets
  security_groups    = [aws_security_group.ecs-alb-internal-security-group.id]
}

resource "aws_security_group" "ecs-alb-internal-security-group" {
  vpc_id = var.vpc_id
  name   = "${lower(var.app_name)}-interanl-alb-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb_target_group" "ecs-alb-internal-tg" {
  for_each = var.target-groups
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

resource "aws_alb_listener" "ecs-internal-alb-listener" {
  load_balancer_arn = aws_alb.ecs-internal-alb.id
  port = 80
  protocol = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No routes defined"
      status_code  = "200"
    }
  }
}

resource "aws_alb_listener_rule" "ecs-internal-alb-listener-rule" {
  for_each = var.target-groups
  listener_arn = aws_alb_listener.ecs-internal-alb-listener.arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.ecs-alb-internal-tg[each.key].arn
  }
  condition {
    path_pattern {
      values = [each.value.path_pattern]
    }
  }
}