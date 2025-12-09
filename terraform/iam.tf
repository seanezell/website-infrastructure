data "aws_iam_policy_document" "github_assume_role" {
    statement {
        effect = "Allow"
        principals {
            type        = "Federated"
            identifiers = [data.aws_iam_openid_connect_provider.github_actions.arn]
        }
        actions = ["sts:AssumeRoleWithWebIdentity"]

        condition {
            test     = "StringLike"
            variable = "token.actions.githubusercontent.com:sub"
            values   = [
                "repo:seanezell/website-infrastructure:*"
            ]
        }

        condition {
            test     = "StringEquals"
            variable = "token.actions.githubusercontent.com:aud"
            values   = ["sts.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "github_actions" {
    name               = "website-infrastructure-githubactions-role"
    assume_role_policy = data.aws_iam_policy_document.github_assume_role.json
    description        = "Role assumed by GitHub Actions for the website-infrastructure repo"
}

# Scoped policy: Terraform will need to manage CloudFront distribution and S3 bucket.
data "aws_iam_policy_document" "deploy_policy" {
    statement {
        sid     = "S3Access"
        effect  = "Allow"
        actions = [
            "s3:ListBucket",
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:PutObjectAcl"
        ]
        resources = [
            aws_s3_bucket.website_bucket.arn,
            "${aws_s3_bucket.website_bucket.arn}/*"
        ]
    }

    statement {
        sid     = "CloudFrontManage"
        effect  = "Allow"
        actions = [
            "cloudfront:CreateInvalidation",
            "cloudfront:GetDistribution",
            "cloudfront:ListDistributions",
            "cloudfront:GetDistributionConfig",
            "cloudfront:UpdateDistribution",
            "cloudfront:CreateDistribution",
            "cloudfront:DeleteDistribution",
            "cloudfront:ListTagsForResource",
            "cloudfront:GetInvalidation",
            "cloudfront:ListInvalidations",
            "cloudfront:GetCloudFrontOriginAccessIdentity"
        ]
        resources = ["arn:aws:cloudfront::736813861381:distribution/EXHLGVHIDDRTJ"]
    }

    statement {
        sid     = "ACMAccess"
        effect  = "Allow"
        actions = ["acm:ListCertificates"]
        resources = ["*"]
    }
}

resource "aws_iam_policy" "deploy_policy" {
    name   = "website-infrastructure-deploy-policy"
    policy = data.aws_iam_policy_document.deploy_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_deploy" {
    role       = aws_iam_role.github_actions.name
    policy_arn = aws_iam_policy.deploy_policy.arn
}
