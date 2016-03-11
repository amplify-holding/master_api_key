module WarpWhistle
  module Components
    module ApiGatekeeper
      extend ActiveSupport::Concern

      module ClassMethods
        def authorize(options = {})
          before_action(options) do
            authorize_action do

            end
          end
        end
      end

      protected

      def authorize_action
        if user_authenticated?
          yield
        else
          respond_with_specified_error('Sorry!! You are not authorized!', :unauthorized)
        end
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