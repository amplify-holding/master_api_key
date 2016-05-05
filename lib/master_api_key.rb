require 'master_api_key/api_gatekeeper'
require 'master_api_key/engine'

ActionController::Base.send :include, MasterApiKey::ApiGatekeeper
ActionController::Base.class_exec do
  authorize_with :authorizers => [:write_authorizer], :only => [:create, :update, :destroy, :new, :edit]
  authorize_with :authorizers => [:read_authorizer], :only => [:index, :show]
end
