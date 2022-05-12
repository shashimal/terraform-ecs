resource "aws_ecs_cluster" "ecs-cluster" {
  name = lower("${var.app_name}-cluster")
}

resource "aws_cloudwatch_log_group" "ecs-cw-log-group" {
  for_each = toset(var.app_services)
  name     = lower("${each.key}-logs")
}

resource "aws_ecs_task_definition" "ecs-task-def" {
  for_each                 = var.task_definition_config
  family                   = "${lower(var.app_name)}-${each.key}"
  execution_role_arn       = var.ecs-task-execution-role-arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = each.value["memory"]
  cpu                      = each.value["cpu"]

  container_definitions = jsonencode([
    {
      name             = each.value["name"]
      image            = "${var.account}.dkr.ecr.${var.region}.amazonaws.com/${lower(var.app_name)}-${lower(each.value["name"])}:latest"
      cpu              = each.value["cpu"]
      memory           = each.value["memory"]
      essential        = true
      portMappings = [
        {
          containerPort = each.value["containerPort"]
          hostPort: each.value["containerPort"]
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          awslogs-group         = "${lower(var.app_name)}-logs"
          awslogs-region        = var.region
          awslogs-stream-prefix = var.app_name
        }
      }
    }
  ])
}
