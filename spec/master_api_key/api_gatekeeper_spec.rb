require 'rails_helper'
require 'master_api_key/api_gatekeeper'

RSpec.describe ApplicationController, :type => :controller do
  context 'with fully configured controller' do
    controller do
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

  context 'with a controller without a group configured' do
    controller do

      def index
        authorize_action do
          head(:ok)
        end
      end
    end

    before(:each) do
      @api_key = MasterApiKey::ApiKey.create!(:group => 'allowed_group')
      controller.request.headers['X-API-TOKEN'] = @api_key.api_token
    end

    it 'should throw exception because the controller is not in a group but is using api authentication' do
      expect{
        controller.index
      }.to raise_error(ArgumentError)
    end
  end

  context 'with a controller with a additional authorizer' do
    controller do
      belongs_to_api_group(:allowed_group)
      authorize_with(:additional_authorizer)

      def index
        authorize_action do
          head(:ok)
        end
      end

      def additional_authorizer
        false
      end
    end

    before(:each) do
      @api_key = MasterApiKey::ApiKey.create!(:group => 'allowed_group')
      controller.request.headers['X-API-TOKEN'] = @api_key.api_token
    end

    it 'should fail authorization when additional authorization factor fails' do
      expect(controller).to receive(:additional_authorizer).and_return(false)
      expect(controller).to receive(:on_forbidden_request).and_call_original
      expect(controller).to receive(:head).with(:forbidden)

      controller.index
    end

    it 'should pass authorization when additional authorization factor succeeds' do
      expect(controller).to receive(:additional_authorizer).and_return(true)
      expect(controller).to receive(:head).with(:ok)

      controller.index
    end
  end

  context 'with a controller with additional authorizers' do
    controller do
      belongs_to_api_group(:allowed_group)
      authorize_with([:first_authorizer, :second_authorizer])

      def index
        authorize_action do
          head(:ok)
        end
      end

      def first_authorizer
        false
      end

      def second_authorizer
        false
      end
    end

    before(:each) do
      @api_key = MasterApiKey::ApiKey.create!(:group => 'allowed_group')
      controller.request.headers['X-API-TOKEN'] = @api_key.api_token
    end

    it 'should fail authorization when one of the additional authorization factors fail' do
      expect(controller).to receive(:first_authorizer).and_return(false)
      expect(controller).to receive(:second_authorizer).and_return(true)

      expect(controller).to receive(:on_forbidden_request).and_call_original
      expect(controller).to receive(:head).with(:forbidden)

      controller.index
    end

    it 'should pass authorization when both authorization factors succeed' do
      expect(controller).to receive(:first_authorizer).and_return(true)
      expect(controller).to receive(:second_authorizer).and_return(true)

      expect(controller).to receive(:head).with(:ok)

      controller.index
    end
  end
end
