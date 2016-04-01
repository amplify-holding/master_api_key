require_dependency 'master_api_key/application_controller'

module MasterApiKey
  class ApiKeysController < ApplicationController
    skip_before_action  :verify_authenticity_token

    # POST /api_keys
    def create
      begin
        @api_key = ApiKey.create!(group:group_param)
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

    # Only allow a trusted parameter "white list" through.
      # def api_key_params
      #   params.require(:api_key).permit(:api_token)
      # end
  end
end