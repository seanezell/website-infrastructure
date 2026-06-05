resource "aws_acm_certificate" "website" {
  provider = aws.useast1

  domain_name               = var.route53_zone_name
  subject_alternative_names = [var.domain_name]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation_website" {
  for_each = {
    for dvo in aws_acm_certificate.website.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
    # Apex validation reuses the existing wildcard cert CNAME record.
    if dvo.domain_name != var.route53_zone_name
  }

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "website" {
  provider = aws.useast1

  certificate_arn = aws_acm_certificate.website.arn
  validation_record_fqdns = concat(
    [aws_route53_record.wildcard_cert_validation.fqdn],
    [for record in aws_route53_record.cert_validation_website : record.fqdn]
  )
}
