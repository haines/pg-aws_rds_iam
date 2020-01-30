data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_iam_user" "postgresql_test_user" {
  name = "postgresql-test"
}

resource "aws_iam_access_key" "postgresql_test_user" {
  user = aws_iam_user.postgresql_test_user.name
}

data "aws_iam_policy_document" "postgresql_test_user" {
  statement {
    actions   = ["rds-db:connect"]
    resources = ["arn:aws:rds-db:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_db_instance.postgresql_test.resource_id}/${local.username}"]
  }

  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress",
    ]

    resources = [aws_security_group.postgresql_test.arn]
  }
}

resource "aws_iam_user_policy" "postgresql_test_user" {
  user   = aws_iam_user.postgresql_test_user.name
  policy = data.aws_iam_policy_document.postgresql_test_user.json
}
