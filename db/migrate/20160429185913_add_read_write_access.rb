class AddReadWriteAccess < ActiveRecord::Migration

  def up
    add_column :master_api_key_api_keys, :read_access, :boolean, :default => false, :null => false
    add_column :master_api_key_api_keys, :write_access, :boolean, :default => false, :null => false
    MasterApiKey::ApiKey.update_all(:read_access => true, :write_access => true)
  end

  def down
    remove_columns :master_api_key_api_keys, :read_access, :write_access
  end
end
