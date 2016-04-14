# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
unless MasterApiKey::ApiKey.where(:group => :master_key).count > 0
  MasterApiKey::ApiKey.create do |master_key|
    master_key.group = :master_key
  end
end
