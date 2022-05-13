output "internal-alb-dns" {
  value = aws_alb.alb.dns_name
}
output "internal-alb-id" {
  value = aws_alb.alb.id
}

output "target-groups" {
  value = aws_alb_target_group.alb-tg
}

output "aws_alb_listener" {
  value = aws_alb_listener.alb-listener
}

