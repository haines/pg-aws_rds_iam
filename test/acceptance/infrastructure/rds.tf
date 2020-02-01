locals {
  username = "test_user"
}

resource "aws_db_instance" "postgresql_test" {
  identifier             = "test"
  instance_class         = "db.t2.micro"
  engine                 = "postgres"
  engine_version         = "11.5"
  allocated_storage      = 20
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.postgresql_test.id]

  username = "root"
  password = var.password
  name     = "test_database"

  iam_database_authentication_enabled = true
}

resource "null_resource" "postgresql_test_user" {
  depends_on = [
    aws_db_instance.postgresql_test,
    aws_security_group_rule.postgresql_test_ingress_allow_postgresql_from_current_ip,
  ]

  provisioner "local-exec" {
    command = "psql --command='CREATE USER ${local.username}; GRANT rds_iam TO ${local.username};'"

    environment = {
      PGHOST     = aws_db_instance.postgresql_test.address
      PGPORT     = aws_db_instance.postgresql_test.port
      PGUSER     = aws_db_instance.postgresql_test.username
      PGPASSWORD = aws_db_instance.postgresql_test.password
      PGDATABASE = aws_db_instance.postgresql_test.name
    }
  }
}
