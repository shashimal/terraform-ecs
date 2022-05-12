output "repository-services" {
  value = [for repository in aws_ecr_repository.ecr-repository: repository.name]
}