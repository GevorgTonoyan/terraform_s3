terraform {
  backend "s3" {
    bucket         = "tfstate-gevorg"
    region         = "eu-central-1"
    key            = "global/s3/terraform.tfstate"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}
