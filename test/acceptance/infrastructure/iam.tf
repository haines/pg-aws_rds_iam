data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_iam_user" "pg_aws_rds_iam_test_user" {
  name = "pg-aws-rds-iam-test"
}

resource "aws_iam_access_key" "pg_aws_rds_iam_test_user" {
  user = aws_iam_user.pg_aws_rds_iam_test_user.name
}

data "aws_iam_policy_document" "pg_aws_rds_iam_test_user" {
  statement {
    actions   = ["rds-db:connect"]
    resources = ["arn:aws:rds-db:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_db_instance.pg_aws_rds_iam_test.resource_id}/${local.username}"]
  }

  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress",
    ]

    resources = [aws_security_group.pg_aws_rds_iam_test.arn]
  }
}

resource "aws_iam_user_policy" "pg_aws_rds_iam_test_user" {
  user   = aws_iam_user.pg_aws_rds_iam_test_user.name
  policy = data.aws_iam_policy_document.pg_aws_rds_iam_test_user.json
}
