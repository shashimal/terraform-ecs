output "vpc-id" {
  value = aws_vpc.ecs-vpc.id
}

output "private-subnets" {
  value = [for subnet in aws_subnet.ecs-public-subnet: subnet.id]
}