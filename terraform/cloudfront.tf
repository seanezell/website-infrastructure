locals {
    origin_id = "s3-${var.website_bucket_name}"
}

provider "aws" {
    alias  = "useast1"
    region = "us-east-1"
}

data "aws_acm_certificate" "issued" {
    provider    = aws.useast1
    domain      = "*.seanezell.com"
    statuses    = ["ISSUED"]
    most_recent = true
}

# resource "aws_cloudfront_origin_access_identity" "oai" {
#     comment = "Origin access identity for ${var.website_bucket_name}"
# }

resource "aws_cloudfront_origin_access_control" "seanezell_oac" {
    name                              = "seanezell-oac"
    description                       = "OAC for seanezell.com bucket"
    origin_access_control_origin_type = "s3"
    signing_behavior                  = "always"          # or "no-override" if you prefer
    signing_protocol                  = "sigv4"
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "website" {
    enabled = true
    comment = "${var.domain_name}"
    price_class = "PriceClass_100"  # US, Canada
    default_root_object = "index.html"
    aliases = [var.domain_name]
    is_ipv6_enabled = true

    origin {
        domain_name = "${var.website_bucket_name}.s3.us-west-2.amazonaws.com"
        origin_id   = local.origin_id
        origin_access_control_id = aws_cloudfront_origin_access_control.seanezell_oac.id
    }

    default_cache_behavior {
        allowed_methods  = ["GET", "HEAD", "OPTIONS"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = local.origin_id
        cache_policy_id  = data.aws_cloudfront_cache_policy.caching_optimized.id
        viewer_protocol_policy = "redirect-to-https"
    }

    custom_error_response {
        error_code            = 403
        response_code         = 200
        response_page_path    = "/index.html"
        error_caching_min_ttl = 10
    }

    custom_error_response {
        error_code            = 404
        response_code         = 200
        response_page_path    = "/index.html"
        error_caching_min_ttl = 10
    }

    viewer_certificate {
        acm_certificate_arn = data.aws_acm_certificate.issued.arn
        ssl_support_method  = "sni-only"
        minimum_protocol_version = "TLSv1.2_2021"
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    tags = {
        Name = "${var.domain_name}"
        Env  = "prod"
    }
}
