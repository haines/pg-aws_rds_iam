# frozen_string_literal: true

require "test_helper"

require "active_record"
require "aws-sdk-ec2"
require "json"
require "open-uri"

class AcceptanceTest < Minitest::Test
  def setup
    configure_aws_credentials
    authorize_ingress
  end

  def teardown
    revoke_ingress
  end

  def test_pg_connect
    connection = PG.connect(uri)

    connection.exec "SELECT TRUE AS success" do |result|
      assert result[0]["success"]
    end
  end

  def test_active_record_base_establish_connection
    ActiveRecord::Base.establish_connection uri
    result = ActiveRecord::Base.connection.exec_query("SELECT TRUE AS success")

    assert result.first["success"]
  end

  private

  def uri
    "#{base_uri}?#{uri_query}"
  end

  def base_uri
    @base_uri ||= ENV.fetch("DATABASE_URL") { terraform_output("database_url") }
  end

  def uri_query
    @uri_query ||= URI.encode_www_form(
      aws_rds_iam_auth_token_generator: "default",
      sslmode: "verify-full",
      sslrootcert: File.expand_path("rds-ca-2019-root.pem", __dir__)
    )
  end

  def terraform_output(name)
    @terraform_outputs ||= Dir.chdir(File.expand_path("infrastructure", __dir__)) { JSON.parse(`terraform output --json`) }

    @terraform_outputs.fetch(name).fetch("value")
  end

  def configure_aws_credentials
    ENV["AWS_ACCESS_KEY_ID"] ||= terraform_output("access_key_id")
    ENV["AWS_SECRET_ACCESS_KEY"] ||= terraform_output("secret_access_key")
    ENV["AWS_REGION"] ||= terraform_output("region")
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
    @security_group_id ||= ENV.fetch("SECURITY_GROUP_ID") { terraform_output("security_group_id") }
  end

  def current_ip
    attempts = 0

    begin
      @current_ip ||= URI.parse("https://ifconfig.co/ip").read.chomp
    rescue OpenURI::HTTPError
      attempts += 1
      raise if attempts > 10

      sleep 1
      retry
    end
  end
end
