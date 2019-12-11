# frozen_string_literal: true

require "test_helper"

module PG
  module AWS_RDS_IAM
    module ConnectionInfo
      class KeywordValueStringTest < Minitest::Test
        def parse(connection_string)
          KeywordValueString.new(connection_string).to_h
        end

        def test_parse_with_empty_string
          assert_equal ({}), parse("")
        end

        def test_parse_with_valid_strings
          expected = { one: "red", two: "orange yellow", three: "'green' blue" }
          [
            "one=red two=orange\\ yellow three=\\'green\\'\\ blue",
            " one = red\n two = orange\\ yellow\n three=\\'green\\'\\ blue\n",
            "one='red' two='orange yellow' three='\\'green\\' blue'"
          ].each do |connection_string|
            assert_equal expected, parse(connection_string)
          end
        end

        def test_parse_with_invalid_strings
          [
            "one=red ohno two=orange",
            "three=yellow =ohno four=green",
            "five=blue six='ohno"
          ].each do |connection_string|
            assert_raises ParseError do
              parse connection_string
            end
          end
        end
      end
    end
  end
end
