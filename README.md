# website-infrastructure

Terraform infrastructure as code for hosting a static website on AWS with CloudFront CDN and S3 origin.

## Architecture

This infrastructure provisions:

- **S3 Bucket**: Hosts static website content
- **CloudFront Distribution**: CDN for global content delivery with HTTPS
- **Origin Access Identity (OAI)**: Secures S3 bucket access to CloudFront only
- **ACM Certificate**: SSL/TLS certificate for custom domain (must be pre-provisioned)
- **IAM Role**: GitHub Actions OIDC role for automated Terraform deployments

## Prerequisites

- AWS account with appropriate permissions
- ACM certificate issued in `us-east-1` for your domain
- GitHub OIDC provider configured in AWS IAM
- S3 bucket for Terraform state: `seanezell-terraform-backend`
- DynamoDB table for state locking: `terraform_state`

## Setup

1. **Configure Terraform variables**
   
   Create `terraform/terraform.tfvars`:
   ```hcl
   website_bucket_name = "your-website-bucket-name"
   domain_name         = "www.yourdomain.com"
   ```

2. **Initialize Terraform**
   ```bash
   cd terraform
   terraform init
   ```

3. **Deploy infrastructure**
   ```bash
   terraform plan
   terraform apply
   ```

## GitHub Actions Deployment

The repository includes automated deployment via GitHub Actions:

- Triggers on pushes to `main` branch affecting `terraform/**` files
- Uses OIDC authentication (no long-lived credentials)
- Automatically runs `terraform plan` and `apply`

**Required GitHub Secret:**
- `AWS_ROLE_ARN`: ARN of the IAM role (output from Terraform)

## Project Structure

```
.
├── .github/workflows/
│   └── terraform-deploy.yml    # CI/CD pipeline
└── terraform/
    ├── main.tf                 # Provider and backend config
    ├── variables.tf            # Input variables
    ├── terraform.tfvars        # Variable values
    ├── s3.tf                   # S3 bucket resources
    ├── cloudfront.tf           # CloudFront distribution
    └── github-oidc.tf          # IAM role for GitHub Actions
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.25.0 |
| <a name="provider_aws.useast1"></a> [aws.useast1](#provider\_aws.useast1) | 6.25.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.oai](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_iam_role.github_actions_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.github_actions_terraform_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_s3_bucket.website_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.website_bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_policy.allow_cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_acm_certificate.issued](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_iam_openid_connect_provider.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | n/a | `string` | `"www.seanezell.com"` | no |
| <a name="input_website_bucket_name"></a> [website\_bucket\_name](#input\_website\_bucket\_name) | S3 bucket name used as the CloudFront origin (existing). | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_actions_role_arn"></a> [github\_actions\_role\_arn](#output\_github\_actions\_role\_arn) | ARN of the IAM role for foundational GitHub Actions |
<!-- END_TF_DOCS -->