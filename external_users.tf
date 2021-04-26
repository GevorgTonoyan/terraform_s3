#create external iam user 
resource "aws_iam_user" "external_user" {
  name = "example_external_user"
}

#policy to allow assume role by external user role
data "template_file" "policy" {
  template = "${file("${path.module}/assume_role_policy.json")}"
  
  vars = {
    principal = "${aws_iam_role.external_users_role.arn}"
  }
}

#iam role for external user
resource "aws_iam_role" "external_users_role" {
  name = "${var.environment}-external_users_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_group" "external_users_group" {
  name = "external-group"
}

resource "aws_iam_policy" "external_users_policy" {
  name        = "test-policy"
  description = "external_users_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${bucket_name}"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "external_users_attach" {
  name       = "external_entity_attachement"
  users      = [aws_iam_user.external_user.name]
  roles      = "${var.environment}-external_users_role"
  groups     = [aws_iam_group.external_users_group.name]
  policy_arn = aws_iam_policy.external_users_policy.arn
}
