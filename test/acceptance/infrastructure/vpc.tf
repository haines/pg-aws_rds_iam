data "http" "current_ip" {
  url = "https://ifconfig.co/ip"
}

locals {
  current_ip = chomp(data.http.current_ip.body)
}

resource "aws_security_group" "pg_aws_rds_iam_test" {
  name_prefix = "pg-aws-rds-iam-test-"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "pg_aws_rds_iam_test_egress_allow_all_to_anywhere" {
  security_group_id = aws_security_group.pg_aws_rds_iam_test.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pg_aws_rds_iam_test_ingress_allow_postgresql_from_current_ip" {
  security_group_id = aws_security_group.pg_aws_rds_iam_test.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = aws_db_instance.pg_aws_rds_iam_test.port
  to_port           = aws_db_instance.pg_aws_rds_iam_test.port
  cidr_blocks       = ["${local.current_ip}/32"]
}
