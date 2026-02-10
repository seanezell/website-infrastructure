# ACM certificate validation
resource "aws_route53_record" "cert_validation" {
    zone_id = var.route53_zone_id
    name    = "_c902b487293dea7cefd9901a4779723a.seanezell.com."
    type    = "CNAME"
    records = ["_a01c4af54a44d0ac1b4a4771523f8ba7.xdvyhgsvzs.acm-validations.aws."]
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