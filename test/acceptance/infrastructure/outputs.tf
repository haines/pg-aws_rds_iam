output "access_key_id" {
  description = "AWS access key ID to use to connect to the test database instance"
  value       = aws_iam_access_key.pg_aws_rds_iam_test_user.id
}

output "database_url" {
  description = "Connection URI for the test database instance"
  value       = "postgresql://${local.username}@${aws_db_instance.pg_aws_rds_iam_test.endpoint}/${aws_db_instance.pg_aws_rds_iam_test.name}"
}

output "region" {
  description = "AWS region of the test database instance"
  value       = data.aws_region.current.name
}

output "secret_access_key" {
  description = "AWS secret access key to use to connect to the test database instance"
  value       = aws_iam_access_key.pg_aws_rds_iam_test_user.secret
}

output "security_group_id" {
  description = "ID of the security group to allow ingress to the test database instance"
  value       = aws_security_group.pg_aws_rds_iam_test.id
}
