resource "github_actions_secret" "aws_access_key_id" {
  repository      = var.github_repository
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = aws_iam_access_key.pg_aws_rds_iam_test_user.id
}

resource "github_actions_secret" "aws_region" {
  repository      = var.github_repository
  secret_name     = "AWS_REGION"
  plaintext_value = data.aws_region.current.name
}

resource "github_actions_secret" "aws_secret_access_key" {
  repository      = var.github_repository
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = aws_iam_access_key.pg_aws_rds_iam_test_user.secret
}

resource "github_actions_secret" "database_url" {
  repository      = var.github_repository
  secret_name     = "DATABASE_URL"
  plaintext_value = local.database_url
}

resource "github_actions_secret" "security_group_id" {
  repository      = var.github_repository
  secret_name     = "SECURITY_GROUP_ID"
  plaintext_value = aws_security_group.pg_aws_rds_iam_test.id
}
