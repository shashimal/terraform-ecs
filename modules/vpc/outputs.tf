output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "private-subnets" {
  value = [for subnet in aws_subnet.private-subnet: subnet.id]
}

output "public-subnets" {
  value = [for subnet in aws_subnet.public-subnet: subnet.id]
}