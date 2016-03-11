class AddApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
<%= migration_data -%>

      t.timestamps null: false
    end
    add_index :api_keys, :api_token, unique: true
end
end
