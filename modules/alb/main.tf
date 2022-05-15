resource "aws_alb" "alb" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = var.security_groups
}

#Dynamically create the alb target groups for app services
resource "aws_alb_target_group" "alb_target_group" {
  for_each = var.target_groups
  name = "${lower(each.key)}-tg"
  port = each.value.port
  protocol = each.value.protocol
  target_type = "ip"
  vpc_id = var.vpc_id

  health_check {
    path = each.value.health_check_path
    protocol = each.value.protocol
  }

}

#Create the alb listener for the load balancer
resource "aws_alb_listener" "alb_listener" {
  for_each = var.listeners
  load_balancer_arn = aws_alb.alb.id
  port = each.value["listener_port"]
  protocol = each.value["listener_protocol"]

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No routes defined"
      status_code  = "200"
    }
  }
}

#Creat listener rules
resource "aws_alb_listener_rule" "alb_listener_rule" {
  for_each = var.target_groups
  listener_arn = aws_alb_listener.alb_listener[each.value.protocol].arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group[each.key].arn
  }
  condition {
    path_pattern {
      values = each.value.path_pattern
    }
  }
}