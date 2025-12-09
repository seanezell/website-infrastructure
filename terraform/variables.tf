variable "aws_region" {
    type    = string
    default = "us-west-2"
}

variable "aws_account_id" {
    type        = string
    description = "Your AWS account id (not secret). Used to reference OIDC provider and role ARNs."
}

variable "website_bucket_name" {
    type        = string
    description = "S3 bucket name used as the CloudFront origin (existing)."
}

variable "domain_name" {
    type        = string
    default     = "www.seanezell.com"
}