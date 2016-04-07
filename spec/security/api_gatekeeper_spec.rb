require 'rails_helper'
require 'security/api_gatekeeper'

RSpec.describe ApplicationController, :type => :controller do
  controller do
    include Security::ApiGatekeeper

    belongs_to_api_group(:allowed_group)

    def index
      authorize_action do
        head(:ok)
      end
    end
  end

  before(:each) do
  end

  context 'Without API TOKEN' do
    it "should return 401 (:unauthorized) if 'X-API-TOKEN' isn't available" do
      expect(controller).to receive(:on_authentication_failure)

      controller.index
    end

    it 'should render a response as unauthorized by default' do
      expect(controller).to receive(:head).with(:unauthorized)

      controller.index
    end
  end

  context 'With API Token' do
    before(:each) do
      @api_key = MasterApiKey::ApiKey.create!(:group => 'allowed_group')
      controller.request.headers['X-API-TOKEN'] = @api_key.api_token
    end

    it "should return 401 (:unauthorized) if the token can't be authenticated" do
      controller.request.headers['X-API-TOKEN'] = @api_key.api_token + '_missing'

      expect(controller).to receive(:on_authentication_failure)

      controller.index
    end

    it "should return 403 (:forbidden) if the api token isn't authorized to access the group" do
      restricted_api_key = MasterApiKey::ApiKey.create!(:group => 'not_allowed_group')
      controller.request.headers['X-API-TOKEN'] = restricted_api_key.api_token

      expect(controller).to receive(:on_forbidden_request).and_call_original
      expect(controller).to receive(:head).with(:forbidden)

      controller.index
    end

    it 'should return 200 if the token is authenticated and authorized to access the controller' do
      expect(controller).to receive(:head).with(:ok)

      controller.index
    end

    it 'should return 200 even if the group is defined with a different character case' do
      upper_case_api_key = MasterApiKey::ApiKey.create!(:group => 'ALLOWED_GROUP')
      controller.request.headers['X-API-TOKEN'] = upper_case_api_key.api_token
      expect(controller).to receive(:head).with(:ok)

      controller.index
    end
  end
end