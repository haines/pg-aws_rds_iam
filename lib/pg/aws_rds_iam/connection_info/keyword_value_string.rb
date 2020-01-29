# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    module ConnectionInfo
      class KeywordValueString
        attr_reader :auth_token_generator_name

        def initialize(connection_string)
          @params = Parser.new(connection_string).parse
          @auth_token_generator_name = @params.delete(:aws_rds_iam_auth_token_generator)
        end

        def user
          @params[:user]
        end

        def host
          @params[:host]
        end

        def port
          @params[:port]
        end

        def password=(value)
          @params[:password] = value
        end

        def to_s
          @params.map { |key, value| "#{key}=#{PG::Connection.quote_connstr(value)}" }.join(" ")
        end

        def to_h
          @params.dup
        end

        class Parser
          def initialize(connection_string)
            @buffer = StringScanner.new(connection_string)
          end

          # @see https://github.com/postgres/postgres/blob/REL_12_1/src/interfaces/libpq/fe-connect.c#L5344-L5457
          def parse
            result = {}

            skip_whitespace
            until @buffer.eos?
              key = parse_key
              skip_whitespace
              assert_followed_by_equals_sign key
              skip_whitespace
              value = parse_value
              skip_whitespace

              result[key] = value
            end

            @buffer.reset
            result
          end

          private

          def skip_whitespace
            @buffer.skip(/\s+/)
          end

          def parse_key
            key = @buffer.scan(/[^=\s]+/)
            raise ParseError, %(Missing parameter name before "#{@buffer.rest}") unless key

            key.to_sym
          end

          def assert_followed_by_equals_sign(key)
            raise ParseError, %(Missing "=" after "#{key}") unless @buffer.getch == "="
          end

          def parse_value
            if @buffer.peek(1) == "'"
              parse_quoted_value
            else
              parse_unquoted_value
            end
          end

          def parse_quoted_value
            value = +""
            @buffer.skip(/'/)
            loop do
              value << (@buffer.scan(/[^'\\]+/) || "")
              case @buffer.getch
              when "'" then return value
              when "\\" then value << (@buffer.getch || "")
              else raise ParseError, "Unterminated quoted value"
              end
            end
          end

          def parse_unquoted_value
            value = +""
            loop do
              value << (@buffer.scan(/[^\s\\]+/) || "")
              return value unless @buffer.getch == "\\"

              value << (@buffer.getch || "")
            end
          end
        end
      end
    end
  end
end
