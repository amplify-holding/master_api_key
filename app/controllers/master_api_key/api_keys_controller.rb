require_dependency 'master_api_key/application_controller'

module MasterApiKey
  class ApiKeysController < ApplicationController
    belongs_to_api_group :master_key
    skip_before_filter  :verify_authenticity_token
    authorize_with :authorizers => [:write_authorizer], :only => [:update_by_access_token, :destroy_by_access_token]

    rescue_from ActionController::ParameterMissing do |exception|
      respond_with_error(exception.message, :bad_request)
    end

    rescue_from ArgumentError do |exception|
      respond_with_error(exception.message, :bad_request)
    end

    #GET /api_keys
    def index
      found_api_key = ApiKey.find_by_api_token(access_token_param)

      check_presence_before_action(found_api_key) do |api_key|
        render json: { api_key: api_key}, status: :ok
      end
    end

    #POST /api_keys
    def create
      authorizers = authorizer_params
      created_api_key = ApiKey.create! do |api_key|
        api_key.group = group_param
        unless authorizers.nil?
          access_types = [TrueClass, FalseClass]
          read_access = authorizers[:read_access]
          write_access = authorizers[:write_access]
          api_key.read_access = enforce_param_type(read_access, :read_access, *access_types) unless read_access.nil?
          api_key.write_access = enforce_param_type(write_access, :write_access, *access_types) unless write_access.nil?
        end
      end

      render json: { api_key: created_api_key}, status: :created
    end

    #PATCH /api_keys/
    def update_by_access_token
      updated_api_key = ApiKey.find_by_api_token(access_token_param)

      check_presence_before_action(updated_api_key) do |api_key|
        api_key.update_attributes(required_auth_params)
        render json: { api_key: api_key}, status: :ok
      end
    end

    # DELETE /api_keys/1
    #deprecated
    def destroy
      ApiKey.delete_all(['id = ?', access_id_param])
      message = 'This method has been deprecated since this is less secure than access by token. It will be removed in v2.0.0'
      render text: message, status: :ok
    end

    # DELETE /api_keys
    def destroy_by_access_token
      Rails.logger.warn "The api token is #{access_token_param}"
      ApiKey.delete_all(['api_token = ?', access_token_param])
      head :ok
    end

    private

    def enforce_param_type(param, param_name,  *types)
      raise ArgumentError.new "Type parameter #{param_name} type should be #{types} " unless types.any? do |type|
        param.is_a? type
      end
      param
    end

    def check_presence_before_action(api_key)
      if api_key.present?
        yield(api_key)
      else
        head :not_found
      end
    end

    def required_auth_params
      params.require(:authorizations).permit(:read_access, :write_access)
    end

    def authorizer_params
      params.permit(:authorizations => [:read_access, :write_access])[:authorizations]
    end

    def group_param
      params.require(:group)
    end

    def access_token_param
      params.require(:api_token)
    end

    def access_id_param
      params.require(:id)
    end
  end
end
