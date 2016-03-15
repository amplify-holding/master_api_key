require 'active_support'

module WarpWhistle
  module Components
    module ApiGatekeeper
      extend ActiveSupport::Concern

      protected

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
        api_token.present? and ApiKey.exists?(access_token: api_token)
      end

      def api_token
        header('X-API-TOKEN')
      end

      def header(header)
        request.headers[header]
      end
    end
  end
end