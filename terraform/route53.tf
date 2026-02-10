# ACM certificate validation
resource "aws_route53_record" "cert_validation" {
    for_each = {
        for dvo in data.aws_acm_certificate.issued.domain_validation_options : dvo.domain_name => {
            name   = dvo.resource_record_name
            record = dvo.resource_record_value
            type   = dvo.resource_record_type
        }
    }

    zone_id = var.route53_zone_id
    name    = each.value.name
    type    = each.value.type
    records = [each.value.record]
    ttl     = 60
}

# website records
resource "aws_route53_record" "www" {
    zone_id = var.route53_zone_id  # hosted zone ID for seanezell.com
    name    = "www"
    type    = "A"

    alias {
        name                   = aws_cloudfront_distribution.website.domain_name
        zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
        evaluate_target_health = false
    }
}

resource "aws_route53_record" "root" {
    zone_id = var.route53_zone_id  # hosted zone ID for seanezell.com
    name    = var.route53_zone_name
    type    = "A"

    alias {
        name                   = aws_cloudfront_distribution.website.domain_name
        zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
        evaluate_target_health = false
    }
}