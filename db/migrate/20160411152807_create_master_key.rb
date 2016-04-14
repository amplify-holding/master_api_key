class CreateMasterKey < ActiveRecord::Migration
  def up
    unless MasterApiKey::ApiKey.where(:group => :master_key).count > 0
      MasterApiKey::ApiKey.create do |master_key|
        master_key.group = :master_key
      end
    end
  end

  def down
    MasterApiKey::ApiKey.where(:group => :master_key).delete_all
  end
end
