require 'rails/generators/active_record'

module WarpWhistle
  module Generators
    # @private
    class ActiveRecordGenerator < ::Rails::Generators::Base

      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def copy_api_keys_migration
        migration_template 'migration.rb', 'db/migrate/add_api_keys.rb'
      end

      def migration_data
        <<RUBY
      t.string :api_token, null: false
      t.string :group, null: false
      t.string :params
      t.datetime :expiry_time
RUBY
      end


      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime('%Y%m%d%H%M%S').to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def create_model
        case self.behavior
          when :invoke
            copy_file 'api_model.rb', 'app/models/api_key.rb'
          when :revoke
            remove_file 'app/models/api_key.rb'
        end
      end

      protected
      def time_to_string
        t = Time.now
        t.strftime('%Y%m%d%H%M%S')
      end

    end
  end
end