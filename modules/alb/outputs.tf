output "internal_alb-dns" {
  value = aws_alb.alb.dns_name
}
output "internal_alb_id" {
  value = aws_alb.alb.id
}

output "target_groups" {
  value = aws_alb_target_group.alb_target_group
}

output "aws_alb_listener" {
  value = aws_alb_listener.alb_listener
}

output "internal_alb" {
  value = aws_alb.alb
}
