# frozen_string_literal: true

require "logger"
require "active_record"
require "aws-sdk-ec2"
require "json"
require "open3"
require "open-uri"

require "test_helper"

class AcceptanceTest < Minitest::Test
  def setup
    authorize_ingress
  end

  def teardown
    revoke_ingress
  end

  def test_pg_connect
    connection = PG.connect(uri)

    connection.exec "SELECT TRUE AS success" do |result|
      assert result.first["success"]
    end
  end

  def test_active_record_base_establish_connection
    ActiveRecord::Base.establish_connection uri
    result = ActiveRecord::Base.connection.exec_query("SELECT TRUE AS success")

    assert result.first["success"]
  end

  def test_active_record_load_schema
    ActiveRecord::Base.establish_connection url: uri, use_metadata_table: false
    db_config = ActiveRecord::Base.connection_db_config

    _, stderr = capture_subprocess_io do
      ActiveRecord::Tasks::DatabaseTasks.load_schema db_config, :sql, File.expand_path("structure.sql", __dir__)
    end

    assert_includes stderr, "🚀"
  end

  def test_rails_dbconsole
    stdout, stderr, status = Open3.capture3(
      {
        "DATABASE_URL" => uri,
        "PGPASSWORD" => "none",
        "PSQLRC" => File.expand_path("rails/.psqlrc", __dir__),
        "RUBYOPT" => "-W0"
      },
      RbConfig.ruby,
      File.expand_path("rails/dbconsole.rb", __dir__),
      stdin_data: "SELECT 'success';\n"
    )

    assert_empty stderr
    assert_equal "success\n", stdout
    assert_predicate status, :success?
  end

  private

  def uri
    "#{base_uri}?#{uri_query}"
  end

  def base_uri
    @base_uri ||= ENV.fetch("DATABASE_URL")
  end

  def uri_query
    @uri_query ||= URI.encode_www_form(
      aws_rds_iam_auth_token_generator: "default",
      sslmode: "verify-full",
      sslrootcert: File.expand_path("us-east-1-bundle.pem", __dir__)
    )
  end

  def authorize_ingress
    Aws::EC2::Client.new.authorize_security_group_ingress(**ingress)
  rescue Aws::EC2::Errors::InvalidPermissionDuplicate # rubocop:disable Lint/SuppressedException
  end

  def revoke_ingress
    Aws::EC2::Client.new.revoke_security_group_ingress(**ingress)
  end

  def ingress
    {
      group_id: security_group_id,
      ip_permissions: [
        {
          ip_protocol: "tcp",
          from_port: 5432,
          to_port: 5432,
          ip_ranges: [{ cidr_ip: "#{current_ip}/32" }]
        }
      ]
    }
  end

  def security_group_id
    @security_group_id ||= ENV.fetch("SECURITY_GROUP_ID")
  end

  def current_ip
    attempts = 0

    begin
      @current_ip ||= URI.parse("https://checkip.amazonaws.com").read.chomp
    rescue OpenURI::HTTPError
      attempts += 1
      raise if attempts > 10

      sleep 1
      retry
    end
  end
end
