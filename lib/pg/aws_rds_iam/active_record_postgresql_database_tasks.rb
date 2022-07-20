# frozen_string_literal: true

module PG
  module AWS_RDS_IAM
    module ActiveRecordPostgreSQLDatabaseTasks
    end

    private_constant :ActiveRecordPostgreSQLDatabaseTasks
  end
end

if ActiveRecord::Tasks::PostgreSQLDatabaseTasks.private_instance_methods.include?(:psql_env)
  require_relative "active_record_postgresql_database_tasks/psql_env"
else
  require_relative "active_record_postgresql_database_tasks/set_psql_env"
end
