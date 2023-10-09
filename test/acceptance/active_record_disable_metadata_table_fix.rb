# frozen_string_literal: true

require "method_source"

EXPECTED_SOURCE = <<RUBY
    def create_table_and_set_flags(environment, schema_sha1 = nil)
      create_table
      update_or_create_entry(:environment, environment)
      update_or_create_entry(:schema_sha1, schema_sha1) if schema_sha1
    end
RUBY

module ActiveRecordDisableMetadataTableFix
  def create_table_and_set_flags(*)
    return unless enabled?

    super
  end
end

if ActiveRecord::InternalMetadata.instance_methods.include?(:create_table_and_set_flags)
  raise "Bug fixed?" unless ActiveRecord::InternalMetadata.instance_method(:create_table_and_set_flags).source == EXPECTED_SOURCE

  ActiveRecord::InternalMetadata.prepend ActiveRecordDisableMetadataTableFix
end
