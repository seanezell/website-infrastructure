variable "website_bucket_name" {
    type        = string
    description = "S3 bucket name used as the CloudFront origin (existing)."
}

variable "domain_name" {
    type        = string
    default     = "www.seanezell.com"
}