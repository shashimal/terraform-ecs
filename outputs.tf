output "vpc-id" {
  value = module.vpc.vpc-id
}

output "private-subnets" {
  value = module.vpc.private-subnets
}

output "internal-alb-dns" {
  value = module.internal-alb.internal-alb-dns
}

output "target-groups" {
  value = module.internal-alb.target-groups
}

output "aws_alb_listener" {
  value = module.internal-alb.aws_alb_listener
}

output "ecr-repositories" {
  value = module.ecr.repository-services
}

output "ecs-task-execution-role-arn" {
  value = module.iam.ecs-task-execution-role-arn
}

output "aws_cloudwatch_log_group" {
  value = module.ecs.aws_cloudwatch_log_group
}

output "aws_ecs_task_definition" {
  value = module.ecs.aws_cloudwatch_log_group
}