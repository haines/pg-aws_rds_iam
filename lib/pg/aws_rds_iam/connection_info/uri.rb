# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    module ConnectionInfo
      class URI
        def self.match?(connection_string)
          /\A#{::URI::ABS_URI_REF}\z/.match?(connection_string)
        end

        attr_reader :auth_token_generator_name

        def initialize(connection_string)
          @uri = ::URI.parse(connection_string)
          @query = @uri.query ? ::URI.decode_www_form(@uri.query).to_h : {}
          @auth_token_generator_name = @query.delete("aws_rds_iam_auth_token_generator")
        end

        def user
          @uri.user || @query["user"]
        end

        def host
          @uri.host || @query["host"]
        end

        def port
          @uri.port || @query["port"]
        end

        def password=(value)
          @uri.password = nil
          @query["password"] = value
        end

        def to_s
          @uri.query = ::URI.encode_www_form(@query)

          @uri.to_s.sub(%r{^#{@uri.scheme}:(?!//)}, "#{@uri.scheme}://")
        end
      end
    end
  end
end
