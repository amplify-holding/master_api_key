require 'active_support'

module Security
  module ApiGatekeeper
    extend ActiveSupport::Concern

    module ClassMethods
      def belongs_to_api_group(group_name)
        raise ArgumentError, "MasterApiKey: Didn't define an api group name" unless group_name.present?

        self.module_eval("def api_group() :#{group_name} end")
      end
    end

    def api_group
      nil
    end

    protected

    def authorize_action
      if user_authenticated?
        raise ArgumentError, "MasterApiKey: Didn't define an api group name" unless self.api_group.present?
        if @api_key.group.casecmp(self.api_group.to_s) == 0
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

    def user_authenticated?
     api_token.present? and (@api_key = MasterApiKey::ApiKey.find_by_api_token(api_token)).present?
    end

    def api_token
      header('X-API-TOKEN')
    end

    def header(header)
      request.headers[header]
    end
  end
end
