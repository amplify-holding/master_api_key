require 'rails_helper'
require 'master_api_key/api_gatekeeper'
require 'support/access_shared_examples'

RSpec.describe ApplicationController, :type => :controller do
  context 'with fully configured controller' do
    controller do
      belongs_to_api_group(:allowed_group)

      def index
        authorize_action do
          head(:ok)
        end
      end

      def show
        authorize_action do
          head(:ok)
        end
      end

      def create
        authorize_action do
          head(:ok)
        end
      end

      def destroy
        authorize_action do
          head(:ok)
        end
      end

      def edit
        authorize_action do
          head(:ok)
        end
      end

      def new
        authorize_action do
          head(:ok)
        end
      end

      def update
        authorize_action do
          head(:ok)
        end
      end
    end

    before(:each) do

    end

    context 'Without API TOKEN' do
      it "should return 401 (:unauthorized) if 'X-API-TOKEN' isn't available" do
        expect(controller).to receive(:on_authentication_failure).and_call_original

        get :index

        expect(response).to have_http_status(401)
      end
    end

    context 'With API Token' do
      before(:each) do
        @api_key = MasterApiKey::ApiKey.create!(:group => 'allowed_group', :read_access => true)
        controller.request.headers['X-API-TOKEN'] = @api_key.api_token
      end

      it "should return 401 (:unauthorized) if the token can't be authenticated" do
        controller.request.headers['X-API-TOKEN'] = @api_key.api_token + '_missing'

        expect(controller).to receive(:on_authentication_failure).and_call_original

        get :index

        expect(response).to have_http_status(401)
      end

      it "should return 403 (:forbidden) if the api token isn't authorized to access the group" do
        restricted_api_key = MasterApiKey::ApiKey.create!(:group => 'not_allowed_group', :read_access => true)
        controller.request.headers['X-API-TOKEN'] = restricted_api_key.api_token

        expect(controller).to receive(:on_forbidden_request).and_call_original

        get :index

        expect(response).to have_http_status(403)
      end

      it 'should return 200 if the token is authenticated and authorized to access the controller' do
        get :index

        expect(response).to have_http_status(200)
      end

      it 'should return 200 even if the group is defined with a different character case' do
        upper_case_api_key = MasterApiKey::ApiKey.create!(:group => 'ALLOWED_GROUP', :read_access => true)
        controller.request.headers['X-API-TOKEN'] = upper_case_api_key.api_token

        get :index

        expect(response).to have_http_status(200)
      end
    end

    context 'with access rights' do
      context 'for index' do
        before(:each) do
          @action = lambda { get :index }
        end

        include_examples :read_access_rights, :allowed_group, :ok
      end

      context 'for show' do
        before(:each) do
          @action = lambda { get :show, :id => 1 }
        end

        include_examples :read_access_rights, :allowed_group, :ok
      end

      context 'for create' do
        before(:each) do
          @action = lambda { post :create}
        end

        include_examples :write_access_rights, :allowed_group, :ok
      end

      context 'for destroy' do
        before(:each) do
          @action = lambda { delete :destroy, :id => 1 }
        end

        include_examples :write_access_rights, :allowed_group, :ok
      end

      context 'for new' do
        before(:each) do
          @action = lambda { get :new, :id => 1}
        end

        include_examples :write_access_rights, :allowed_group, :ok
      end

      context 'for edit' do
        before(:each) do
          @action = lambda { post :edit, :id => 1 }
        end

        include_examples :write_access_rights, :allowed_group, :ok
      end

      context 'for put' do
        before(:each) do
          @action = lambda { put :update, :id => 1 }
        end

        include_examples :write_access_rights, :allowed_group, :ok
      end

      context 'for patch' do
        before(:each) do
          @action = lambda { patch :update, :id => 1 }
        end

        include_examples :write_access_rights, :allowed_group, :ok
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
      @api_key = MasterApiKey::ApiKey.create!(:group => 'allowed_group', :read_access => true)
      controller.request.headers['X-API-TOKEN'] = @api_key.api_token
    end

    it 'should throw exception because the controller is not in a group but is using api authentication' do
      expect{
        get :index
      }.to raise_error(ArgumentError)
    end
  end

  context 'with a controller with additional authorizers' do
    class ExtendedApiKey < MasterApiKey::ApiKey
       def allowed_id
         nil
       end

       def allowed_filter
         nil
       end
    end

    controller do
      belongs_to_api_group(:allowed_group)
      authorize_with authorizers: [:first_authorizer, :second_authorizer], only:[:index]

      def index
        head(:ok)
      end

      def show
        authorize_action(:first_authorizer) do
          head(:ok)
        end
      end

      def first_authorizer
        @api_key.allowed_id == params.require(:id).to_i
      end

      def second_authorizer
        @api_key.allowed_filter == params.require(:filter)
      end
    end

    before(:each) do
      @allowed_filter = 'allowed_key'
      @valid_api_key = ExtendedApiKey.create!(:group => 'allowed_group', :read_access => true)
      controller.request.headers['X-API-TOKEN'] = @valid_api_key.api_token

      allow(MasterApiKey::ApiKey).to receive(:find_by_api_token).with(@valid_api_key.api_token).and_return(@valid_api_key)
      allow(@valid_api_key).to receive(:allowed_id).and_return(1)
      allow(@valid_api_key).to receive(:allowed_filter).and_return(@allowed_filter)
    end

    context 'with two additional authorization factors' do
      it 'should fail authorization when one of the additional authorization factors fail' do
        get :index, :id => 1, :filter => 'not_allowed_filter'

        expect(response).to have_http_status(403)
      end

      it 'should pass authorization when both authorization factors succeed' do
        get :index, :id => 1, :filter => @allowed_filter

        expect(response).to have_http_status(200)
      end
    end

    context 'with one additional authorization factor' do
      it 'should pass authorization when additional authorization factor succeeds' do
        get :show, :id => 1

        expect(response).to have_http_status(200)
      end

      it 'should fail authorization when additional authorization factor fails' do

        get :show, :id => 2

        expect(response).to have_http_status(403)
      end
    end
  end
end
