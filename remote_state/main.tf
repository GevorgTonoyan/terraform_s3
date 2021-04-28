provider "aws" {
	region = "eu-central-1"
    profile = "default"
}

resource "aws_s3_bucket" "terraform_state" {
	bucket = "tfstate-gevorg"

    lifecycle {
        prevent_destroy = true
    }

    versioning {
    	enabled = true
  	}

    server_side_encryption_configuration {
      rule {
          apply_server_side_encryption_by_default {
              sse_algorithm = "AES256"
          }
      }
    }

    tags = {
    	Name = "remote-state"
        Environment = "Development"
    }
}

resource "aws_dynamodb_table" "terraform_lock" {
    name = "terraform-state-locking"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
      name = "LockID"
      type = "S"
    }
}
