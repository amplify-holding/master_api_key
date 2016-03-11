require 'warp_whistle/components/api_gatekeeper'

module WarpWhistle
  class ApiKey
    include Components::ApiGatekeeper
    def self.hi
      puts 'Hello world!'
    end
  end
end