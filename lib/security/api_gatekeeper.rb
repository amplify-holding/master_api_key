require 'active_support'

module Security
  module ApiGatekeeper
    extend ActiveSupport::Concern

    protected

    def authorize_action_filter
      unless user_authenticated?
        on_authentication_failure
      end
    end

    def authorize_action
      if user_authenticated?
        yield
      else
        on_authentication_failure
      end
    end

    def on_authentication_failure
      head(:unauthorized)
    end

    def on_forbidden_request
      head(:forbidden)
    end

    private

    def user_authenticated?
      api_token.present? and ApiKey.exists?(api_token: api_token)
    end

    def api_token
      header('X-API-TOKEN')
    end

    def header(header)
      request.headers[header]
    end
  end
end
