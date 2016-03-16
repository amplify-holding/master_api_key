require 'active_support/all'

class ApiKey
  def self.exists?(api_token)
    api_token.present?
  end
end