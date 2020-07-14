# frozen_string_literal: true

require "test_helper"

require "uri"

module PG
  class ConnectionTest < Minitest::Test
    def setup
      AWS_RDS_IAM.auth_token_generators.add :example_auth_token_generator do
        ->(host:, port:, user:) { "token(#{user}@#{host}:#{port})" }
      end
    end

    def teardown
      AWS_RDS_IAM.auth_token_generators.remove :example_auth_token_generator
    end

    def test_conndefaults_hash
      assert_nil Connection.conndefaults_hash.fetch(:aws_rds_iam_auth_token_generator)
    end

    def test_parse_connect_args_to_uri
      {
        ["postgresql://example_user@localhost:5432/example_database?aws_rds_iam_auth_token_generator=example_auth_token_generator"] => "postgresql://example_user@localhost:5432/example_database?password=token(example_user@localhost:5432)",
        ["postgresql://?user=example_user&host=localhost&port=5432&dbname=example_database&aws_rds_iam_auth_token_generator=example_auth_token_generator"] => "postgresql://?user=example_user&host=localhost&port=5432&dbname=example_database&password=token(example_user@localhost:5432)",
        ["postgresql://", { user: "example_user", host: "localhost", port: 5432, dbname: "example_database", aws_rds_iam_auth_token_generator: "example_auth_token_generator" }] => "postgresql://?user=example_user&host=localhost&port=5432&dbname=example_database&password=token(example_user@localhost:5432)"
      }.each do |args, expected|
        assert_uri_match expected, Connection.parse_connect_args(*args)
      end
    end

    def test_parse_connect_args_to_keyword_value_string
      expected = "user='example_user' host='localhost' port='5432' dbname='example_database' password='token(example_user@localhost:5432)'"

      [
        ["user=example_user host=localhost port=5432 dbname=example_database aws_rds_iam_auth_token_generator=example_auth_token_generator"],
        [{ user: "example_user", host: "localhost", port: 5432, dbname: "example_database", aws_rds_iam_auth_token_generator: "example_auth_token_generator" }],
        ["localhost", 5432, nil, nil, "example_database", "example_user", nil, { aws_rds_iam_auth_token_generator: "example_auth_token_generator" }]
      ].each do |args|
        assert_keyword_value_string_match expected, Connection.parse_connect_args(*args)
      end
    end

    private

    def assert_uri_match(expected, actual)
      expected_uri, expected_query = parse_uri(expected)
      actual_uri, actual_query = parse_uri(actual)
      actual_query.delete "fallback_application_name"

      assert_equal expected_uri, actual_uri
      assert_equal expected_query, actual_query
    end

    def parse_uri(connection_string)
      uri = URI.parse(connection_string)
      query = URI.decode_www_form(uri.query).to_h
      uri.query = nil

      [uri, query]
    end

    def assert_keyword_value_string_match(expected, actual)
      expected_params = parse_keyword_value_string(expected)
      actual_params = parse_keyword_value_string(actual)
      actual_params.delete :fallback_application_name

      assert_equal expected_params, actual_params
    end

    def parse_keyword_value_string(connection_string)
      AWS_RDS_IAM.const_get(:ConnectionInfo)::KeywordValueString.new(connection_string).to_h
    end
  end
end
