resource "aws_ecs_cluster" "ecs_cluster" {
  name = lower("${var.app_name}-cluster")
}

resource "aws_cloudwatch_log_group" "ecs_cw_log_group" {
  for_each = toset(var.app_services)
  name     = lower("${each.key}-logs")
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  for_each                 = var.service_config
  family                   = "${lower(var.app_name)}-${each.key}"
  execution_role_arn       = var.ecs_task_execution_role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = each.value["memory"]
  cpu                      = each.value["cpu"]

  container_definitions = jsonencode([
    {
      name         = each.value["name"]
      image        = "${var.account}.dkr.ecr.${var.region}.amazonaws.com/${lower(var.app_name)}-${lower(each.value["name"])}:latest"
      cpu          = each.value["cpu"]
      memory       = each.value["memory"]
      essential    = true
      portMappings = [
        {
          containerPort = each.value["container_port"]
          hostPort : each.value["container_port"]
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          awslogs-group         = "${lower(each.value["name"])}-logs"
          awslogs-region        = var.region
          awslogs-stream-prefix = var.app_name
        }
      }
    }
  ])
}

resource "aws_ecs_service" "private_service" {
  for_each = var.service_config

  name            = "${each.value["name"]}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition[each.key].arn
  launch_type     = "FARGATE"
  desired_count = each.value["desired_count"]

  network_configuration {
    subnets          = each.value["public_service"] ==true ? var.public_subnets : var.private_subnets
    assign_public_ip = each.value["public_service"] ==true ? true : false
    security_groups  = [
      each.value["public_service"] == true ? aws_security_group.webapp_security_group.id : aws_security_group.service_security_group.id
    ]
  }

  load_balancer {
    target_group_arn = each.value["public_service"] ==true ? var.public_alb_target_groups[each.key].arn :var.internal_alb_target_groups[each.key].arn
    container_name = each.value["name"]
    container_port =each.value["container_port"]
  }

}

resource "aws_security_group" "service_security_group" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [var.internal_alb_security_group.security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "webapp_security_group" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [var.public_alb_security_group.security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}