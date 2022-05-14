## Application
account      = 00000000
region       = "us-east-1"
app_name     = "HBCU"
env          = "PROD"
app_services = ["webapp", "customer", "transaction"]

#VPC
cidr               = "10.10.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnets     = ["10.10.50.0/24", "10.10.51.0/24"]
private_subnets    = ["10.10.0.0/24", "10.10.1.0/24"]

#ALB
internal_alb_ingress_rules = [
  {
    from_port   = 80
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }
]

internal_alb_egress_rules = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.10.0.0/16"]
  }
]

public_alb_ingress_rules = [
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

public_alb_egress_rules = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

internal_alb_target_groups = {
  "customer" = {
    service_name = "customer"
    port         = 80
    protocol     = "HTTP"
    path_pattern = "/customer*"
    health_check = {
      path = "/health"
    }
  },
  "transaction" = {
    service_name = "transaction"
    port         = 80
    path_pattern = "/transaction*"
    protocol     = "HTTP"
    health_check = {
      path = "/health"
    }
  }
}

public_alb_target_groups = {
  "webapp" = {
    service_name = "webapp"
    port         = 80
    protocol     = "HTTP"
    path_pattern = "/*"
    health_check = {
      path = "/health"
    }
  }
}

#ECS
service_config = {
  "webapp" = {
    name          = "webapp"
    cpu           = 256
    memory        = 512
    container_port = 80
    desired_count = 1
    public_service = true
  },
  "customer" = {
    name          = "customer"
    cpu           = 256
    memory        = 512
    container_port = 3000
    desired_count = 1
    public_service = false
  },
  "transaction" = {
    name          = "transaction"
    cpu           = 256
    memory        = 512
    container_port = 3000
    desired_count = 1
    public_service = false
  }
}
