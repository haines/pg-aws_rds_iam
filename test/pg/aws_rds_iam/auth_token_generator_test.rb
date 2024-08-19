# frozen_string_literal: true

require "test_helper"

module PG
  module AWS_RDS_IAM
    class AuthTokenGeneratorTest < Minitest::Test
      def setup
        credentials = Aws::Credentials.new("AKIAIOSFODNN7EXAMPLE", "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY")
        @auth_token_generator = AuthTokenGenerator.new(credentials:, region: "eu-west-2")
      end

      def test_generate_token
        Timecop.freeze "2001-02-03T04:05:06.789Z" do
          token = @auth_token_generator.call(host: "localhost", port: "5432", user: "example_user")

          uri = URI.parse("https://#{token}")

          assert_equal "localhost", uri.host
          assert_equal 5432, uri.port

          query = URI.decode_www_form(uri.query).to_h

          assert_equal "connect", query["Action"]
          assert_equal "example_user", query["DBUser"]
          assert_equal "AKIAIOSFODNN7EXAMPLE/20010203/eu-west-2/rds-db/aws4_request", query["X-Amz-Credential"]
          refute_empty query["X-Amz-Signature"]
        end
      end
    end
  end
end
