require 'security/api_gatekeeper'
require 'master_api_key/engine'

module MasterApiKey

end

ActionController::Base.send :include, Security::ApiGatekeeper
