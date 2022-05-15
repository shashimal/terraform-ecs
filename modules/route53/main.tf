resource "aws_route53_zone" "private_zone" {
  name = var.internal_url_name
  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "internal_service_record" {
  name    = var.internal_url_name
  type    = "A"
  zone_id = aws_route53_zone.private_zone.zone_id

  alias {
    evaluate_target_health = true
    name                   = var.alb.dns_name
    zone_id                = var.alb.zone_id
  }
}