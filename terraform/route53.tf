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