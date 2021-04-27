data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.account_id]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [var.external_id]
    }
  }
}

data "aws_iam_policy_document" "internal_users" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
    effect    = "Allow"
  }
  statement {
    sid       = "InternalUsersS3all"
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.important-bucket.arn]
    effect    = "Allow"
  }
}

data "aws_iam_policy_document" "contractors1" {
  statement {
    actions   = ["s3:GetObject", "s3:GetObjectVersion"]
    resources = [aws_s3_bucket.contractors-bucket.arn]
    effect    = "Allow"
  }
}

data "template_file" "josh_policy" {
  template = file("${path.module}/iam_policies/${var.environment}_policy.json")

  vars = {
    bucket_name = aws_s3_bucket.important-bucket.id
    principal   = aws_iam_user.internal_user.arn
  }

}
