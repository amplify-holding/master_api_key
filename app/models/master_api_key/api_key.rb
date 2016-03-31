module MasterApiKey
  class ApiKey < ActiveRecord::Base
    validates :group, presence: true
    before_create :generate_api_token

    def as_json(options = {})
      super(options.reverse_merge({only: [:id, :api_token, :group]}))
    end

    private

    def generate_api_token
      self.api_token ||= SecureRandom.urlsafe_base64
    end
  end
end
