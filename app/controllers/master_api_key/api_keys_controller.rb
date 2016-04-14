require_dependency 'master_api_key/application_controller'

module MasterApiKey
  class ApiKeysController < ApplicationController
    belongs_to_api_group :master_key
    skip_before_filter  :verify_authenticity_token
    before_filter :authorize_action

    # POST /api_keys
    def create
      begin
        @api_key = ApiKey.create! do |api_key|
          api_key.group = group_param
        end
        render json: { apiKey: @api_key, status: :created }
      rescue ActionController::ParameterMissing => e
        respond_with_error(e.message, :bad_request)
      end
    end

    # DELETE /api_keys/1
    def destroy
      begin
        ApiKey.delete_all(['id = ?', access_id_param])
        head :ok
      rescue ActionController::ParameterMissing => e
        respond_with_error(e.message, :bad_request)
      end
    end

    # DELETE /api_keys
    def destroy_by_access_token
      begin
        Rails.logger.warn "the api token is #{access_token_param}"
        ApiKey.delete_all(['api_token = ?', access_token_param])
        head :ok
      rescue ActionController::ParameterMissing => e
        respond_with_error(e.message, :bad_request)
      end
    end

    private

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
