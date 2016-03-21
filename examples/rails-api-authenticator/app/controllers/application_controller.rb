require 'security/api_gatekeeper'

class ApplicationController < ActionController::Base
  include Security::ApiGatekeeper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  respond_to :html, :xml, :json

  def respond_with_error(msg)
    respond_with_specified_error(msg, :bad_request)
  end

  def respond_with_specified_error(msg, error)
    render :text => {:error => msg}.to_json, :content_type => 'application/json', :status => error
  end

end
