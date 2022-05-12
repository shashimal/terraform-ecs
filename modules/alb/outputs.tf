output "internal-alb-dns" {
  value = aws_alb.ecs-internal-alb.dns_name
}
output "internal-alb-id" {
  value = aws_alb.ecs-internal-alb.id
}

output "target-groups" {
  value = aws_alb_target_group.ecs-alb-internal-tg
}

output "aws_alb_listener" {
  value = aws_alb_listener.ecs-internal-alb-listener
}

