require 'active_support'

module MasterApiKey
  module ApiGatekeeper
    extend ActiveSupport::Concern

    module ClassMethods
      def belongs_to_api_group(group_name)
        raise ArgumentError, "MasterApiKey: Didn't define an api group name" unless group_name.present?

        self.module_eval("def api_group() :#{group_name} end")
      end

      def authorize_with(options)
        before_filter(options) do
          authorizers = options[:authorizers]
          raise ArgumentError, "Didn't define authorizers with method" unless authorizers.present?

          authorize_action(authorizers)
        end
      end
    end

    def api_group
      nil
    end

    protected

    def passes_authorizers?(authorizers)
      method_definitions = authorizers.respond_to?(:inject) ? authorizers : [authorizers]
      method_definitions.inject(true) do |authorized, authorizer|
        authorized &= self.send(authorizer)
      end
    end

    def authorize_action(authorizers = nil)
      if user_authenticated?
        raise ArgumentError, "MasterApiKey: Didn't define an api group name" unless self.api_group.present?

        if authorized_with_group? and (authorizers.nil? or passes_authorizers?(authorizers))
          yield if block_given?
        else
          on_forbidden_request
        end
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

    def authorized_with_group?
      @api_key.group.casecmp(self.api_group.to_s) == 0
    end

    def user_authenticated?
      api_token.present? and user_api_key.present?
    end

    def user_api_key
      @api_key.present? ? @api_key : (@api_key = MasterApiKey::ApiKey.find_by_api_token(api_token))
    end

    def api_token
      header('X-API-TOKEN')
    end

    def header(header)
      request.headers[header]
    end
  end
end
