variable "website_bucket_name" {
    type        = string
    description = "S3 bucket name used as the CloudFront origin (existing)."
}

variable "domain_name" {
    type        = string
}

variable "route53_zone_name" {
    type    = string
}

variable "route53_zone_id" {
    description = "Hosted Zone ID for seanezell.com (created in account-level infrastructure)"
    type        = string
}