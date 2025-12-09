terraform {
    backend "s3" {
        bucket = "seanezell-terraform-backend"
        key = "website-infrastructure/terraform.tfstate"
        region = "us-west-2"
        dynamodb_table = "terraform_state"
    }
}

