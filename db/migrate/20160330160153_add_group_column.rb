class AddGroupColumn < ActiveRecord::Migration
  def change
    add_column :master_api_key_api_keys, :group, :string
  end
end
