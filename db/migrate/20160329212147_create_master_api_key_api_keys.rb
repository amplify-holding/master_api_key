class CreateMasterApiKeyApiKeys < ActiveRecord::Migration
  def change
    create_table :master_api_key_api_keys do |t|
      t.string :api_token

      t.timestamps null: false
    end
  end
end
