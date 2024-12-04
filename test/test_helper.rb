# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "pg/aws_rds_iam"

require "minitest/reporters"
Minitest::Reporters.use!

require "timecop"
Timecop.mock_process_clock = true
Timecop.safe_mode = true

require "minitest/autorun"
