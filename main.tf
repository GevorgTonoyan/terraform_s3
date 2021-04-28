resource "aws_s3_bucket" "important-bucket" {
  bucket = "${var.environment}-important-stuff"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
  }

  tags = {
    Name        = "important-${var.environment}-stuff"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "contractors-bucket" {
  bucket = "${var.environment}-contractor-development"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
  }

  tags = {
    Name        = "${var.environment}-contractor-development"
    Environment = var.environment
  }
}
