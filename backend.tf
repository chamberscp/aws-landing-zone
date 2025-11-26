terraform {
  backend "s3" {
    bucket         = "chamberscp-terraform-state-2025"
    key            = "global/landing-zone/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
