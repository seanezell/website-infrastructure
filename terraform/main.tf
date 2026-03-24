terraform {
    required_version = ">= 1.14.0"
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
    backend "s3" {
        bucket = "seanezell-terraform-backend"
        key = "website-infrastructure/terraform.tfstate"
        region = "us-west-2"
        encrypt      = true
        use_lockfile = true
    }
}

