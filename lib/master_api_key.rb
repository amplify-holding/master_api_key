require 'security/api_gatekeeper'

module MasterApiKey

end

ActionController::Base.send :include, Security::ApiGatekeeper
