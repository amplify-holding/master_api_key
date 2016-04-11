class CreateMasterKey < ActiveRecord::Migration
  def up
    unless MasterApiKey::ApiKey.where(:group => :master_key).count > 0
      MasterApiKey::ApiKey.create(:group => :master_key)
    end
  end

  def down
    MasterApiKey::ApiKey.where(:group => :master_key).delete_all
  end
end
