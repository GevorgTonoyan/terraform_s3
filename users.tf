# create group for external company
resource "aws_iam_group" "contractor1_group" {
  name = "external-developers"
}

resource "aws_iam_group" "internal_group" {
  name = "internal-developers"
}

resource "aws_iam_group_membership" "internal_team" {
  name = "internal-team-group"

  users = [
    aws_iam_user.internal_user.name,
  ]

  group = aws_iam_group.internal_group.name
}

resource "aws_iam_group_membership" "contractor1_group" {
  name = "contractor-team-group"

  users = [
    aws_iam_user.contractor_developer1.name,
  ]

  group = aws_iam_group.contractor1_group.name
}

# create users
resource "aws_iam_user" "contractor_developer1" {
  name = "contractor-developer1"
}

resource "aws_iam_user" "internal_user" {
  name = "example-internal-employee"
}

resource "aws_iam_user" "other_user" {
  name = "Josh"
}

# policy and roles
resource "aws_iam_role" "assume_role" {
  name                  = "contractors1-assume-role"
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
  force_detach_policies = true
}

resource "aws_iam_policy" "s3_policy" {
  name   = "${var.environment}-internal-s3-policy"
  policy = data.aws_iam_policy_document.internal_users.json
}

resource "aws_iam_policy" "contractor_s3_readonly" {
  name   = "${var.environment}-contractor-s3-readonly"
  policy = data.aws_iam_policy_document.contractors1.json
}

# attach policy
resource "aws_iam_role_policy_attachment" "contractor1_attachement" {
  role       = aws_iam_role.assume_role.name
  policy_arn = aws_iam_policy.contractor_s3_readonly.arn
}

resource "aws_iam_policy_attachment" "internal_group_attach" {
  name       = "internal-devs-attach"
  users      = [aws_iam_user.internal_user.name]
  groups     = [aws_iam_group.internal_group.name]
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_policy_attachment" "contractor_group_attach" {
  name       = "contractors-attach"
  users      = [aws_iam_user.contractor_developer1.name]
  groups     = [aws_iam_group.contractor1_group.name]
  policy_arn = aws_iam_policy.contractor_s3_readonly.arn
}

# Josh
resource "aws_iam_policy" "policy" {
  name        = "${var.environment}-internal-user-policy"
  description = "My test policy"
  policy      = data.template_file.josh_policy.rendered
}

resource "aws_iam_user_policy" "internal_user_bucket_access" {
  name   = "Josh-policy"
  user   = aws_iam_user.other_user.name
  policy = data.template_file.josh_policy.rendered
}
