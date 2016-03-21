class ApiKeyController < ApplicationController

  skip_before_action  :verify_authenticity_token

  def create
    begin
      api_key = ApiKey.create!(group:group_param)
      render json: {apiKey: api_key, status: :created}
    rescue ActionController::ParameterMissing => e
      respond_with_error e.message
    end
  end

  def destroy
    begin
      ApiKey.delete_all(['id = ?', access_id_param])
      head :ok
    rescue ActionController::ParameterMissing => e
      respond_with_error e.message
    end
  end

  def destroy_by_access_token
    begin
      ApiKey.delete_all(['access_token = ?', access_token_param])
      head :ok
    rescue ActionController::ParameterMissing => e
      respond_with_error e.message
    end
  end

  private

  def group_param
    params.require(:group)
  end

  def access_token_param
    params.require(:access_token)
  end

  def access_id_param
    params.require(:id)
  end
end
