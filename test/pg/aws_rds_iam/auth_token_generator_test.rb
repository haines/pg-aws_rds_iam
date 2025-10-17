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
          tokens = [
            { host: "localhost", port: "5432", user: "example_user" },
            { host: "localhost", port: "5432", user: "another_user" },
            { host: "localhost", port: "4321", user: "example_user" },
            { host: "127.0.0.1", port: "5432", user: "example_user" }
          ].map { |params| [params, @auth_token_generator.call(**params)] }

          unique_tokens = tokens.uniq { |(_, token)| token }

          assert_equal tokens, unique_tokens

          tokens.each do |params, token|
            assert_token token, **params

            Timecop.freeze 839.9 do
              assert_equal token, @auth_token_generator.call(**params)
            end

            Timecop.freeze 840.1 do
              new_token = @auth_token_generator.call(**params)

              refute_equal token, new_token
              assert_token new_token, **params
            end
          end
        end
      end

      def assert_token(token, host:, port:, user:)
        uri = URI.parse("https://#{token}")

        assert_equal host, uri.host
        assert_equal Integer(port, 10), uri.port

        query = URI.decode_www_form(uri.query).to_h

        assert_equal "connect", query["Action"]
        assert_equal user, query["DBUser"]
        assert_equal "AKIAIOSFODNN7EXAMPLE/20010203/eu-west-2/rds-db/aws4_request", query["X-Amz-Credential"]
        refute_empty query["X-Amz-Signature"]
      end
    end
  end
end
