resource "aws_s3_bucket" "website_bucket" {
    bucket = var.website_bucket_name

    tags = {
        Name = "website-bucket-${var.website_bucket_name}"
        Env  = "prod"
    }
}

resource "aws_s3_bucket_acl" "website_bucket_acl" {
    bucket = aws_s3_bucket.website_bucket.id
    acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "block" {
    bucket                  = aws_s3_bucket.website_bucket.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

# Give CloudFront OAI read access to bucket objects
resource "aws_s3_bucket_policy" "allow_cloudfront" {
    bucket = aws_s3_bucket.website_bucket.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Sid       = "AllowCloudFrontServicePrincipalReadOnly"
            Effect    = "Allow"
            Principal = {
            AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
            }
            Action   = ["s3:GetObject", "s3:ListBucket"]
            Resource = [
            "${aws_s3_bucket.website_bucket.arn}",
            "${aws_s3_bucket.website_bucket.arn}/*"
            ]
        }
        ]
    })
}
