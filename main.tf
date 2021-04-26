resource "aws_iam_user" "internal_user" {
  name = "example_internal_employee"
}

resource "aws_iam_user" "external_user" {
  name = "example_external_user"
}

resource "aws_iam_access_key" "internal_user_access_key" {
  user = "${aws_iam_user.internal_user.name}"
}

resource "aws_iam_role" "external_users_role" {
  name = "${var.environment}-external_users_role"

data "template_file" "policy" {
  template = "${file("${path.module}/assume_role_policy.json")}"
  
  vars = {
    principal = "${aws_iam_role.exterma_users_role.arn}"
  }

resource "aws_s3_bucket" "important-bucket" {
	bucket = "${var.environment}-important-stuff"
    acl = "private"

    versioning {
    	enabled = true
  	}

    lifecycle_rule {
        enabled = true
    }

    tags = {
    	Name = "important-${var.environment}-stuff"
        Environment = var.environment
    }
}

data "template_file" "policy" {
  template = "${file("${path.module}/${var.environment}_policy.json")}"
  
  vars = {
    bucket_name = "${var.environment}-important-stuff"
    principal = "${aws_iam_user.internal_user.arn}"
  }

}

resource "aws_iam_policy" "policy" {
  name        = "${var.environment}-internal_user_policy"
  description = "My test policy"
  policy = "${data.template_file.policy.rendered}"
}

resource "aws_iam_user_policy" "internal_user_bucket_access" {
  name = "internal_users_bucket_policy"
  user = "${aws_iam_user.internal_user.name}"
  policy = "${data.template_file.policy.rendered}"
}
