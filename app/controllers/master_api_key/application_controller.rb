module MasterApiKey
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    protected

    def respond_with_error(msg, error)
      render json: {:error => msg}, status: error
    end
  end
end
