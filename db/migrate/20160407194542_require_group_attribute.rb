class RequireGroupAttribute < ActiveRecord::Migration
  def change
    change_column_null :master_api_key_api_keys, :group, false
  end
end
