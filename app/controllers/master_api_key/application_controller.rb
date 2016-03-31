module MasterApiKey
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    protected

    def respond_with_error(msg, error)
      render :text => {:error => msg}.to_json, :content_type => 'application/json', :status => error
    end
  end
end
