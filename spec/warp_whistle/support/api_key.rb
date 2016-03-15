require 'active_support/all'

class ApiKey
  def self.exists?(access_token)
    access_token.present?
  end
end