resource "aws_ecr_repository" "ecr-repository" {
  for_each = toset(var.ecr_repository_services)
  name = lower("${var.app_name}-${each.key}")
}