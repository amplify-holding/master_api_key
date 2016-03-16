require 'security/api_gatekeeper'

class MasterApiKey
  include Security::ApiGatekeeper
  def self.hi
    puts 'Hello world!'
  end
end
