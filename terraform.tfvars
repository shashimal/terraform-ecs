## Application
account      = 00000000000
region       = "us-east-1"
app_name     = "HBCU"
env          = "PROD"
app_services = ["customer", "transaction", "portfolio"]

#VPC
cidr               = "10.10.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnets     = ["10.10.50.0/24", "10.10.51.0/24"]
private_subnets    = ["10.10.0.0/24", "10.10.1.0/24"]

#ALB
target-groups = {
  "customer" = {
    service_name = "customer"
    port         = 80
    protocol     = "HTTP"
    path_pattern = "/customer*"
    health_check = {
      path = "/"
    }
  },
  "transaction" = {
    service_name = "transaction"
    port         = 80
    path_pattern = "/transaction*"
    protocol     = "HTTP"
    health_check = {
      path = "/"
    }
  },
  "portfolio" = {
    service_name = "portfolio"
    port         = 80
    path_pattern = "/portfolio*"
    protocol     = "HTTP"
    health_check = {
      path = "/"
    }
  }
}

#ECS
task_definition_config = {
  "customer" = {
    name          = "customer"
    cpu           = 256
    memory        = 512
    containerPort = 80
  },
  "transaction" = {
    name          = "transaction"
    cpu           = 256
    memory        = 512
    containerPort = 80
  }
  "portfolio" = {
    name          = "portfolio"
    cpu           = 256
    memory        = 512
    containerPort = 80
  }
}
