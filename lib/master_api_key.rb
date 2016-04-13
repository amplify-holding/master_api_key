require 'master_api_key/api_gatekeeper'
require 'master_api_key/engine'

ActionController::Base.send :include, MasterApiKey::ApiGatekeeper
