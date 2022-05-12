output "aws_cloudwatch_log_group" {
  value = [for log-group in aws_cloudwatch_log_group.ecs-cw-log-group:  log-group.name]
}

output "aws_ecs_task_definition" {
  value = [for taskdef in aws_ecs_task_definition.ecs-task-def : taskdef]
}