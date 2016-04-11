require 'rails_helper'

module MasterApiKey
  RSpec.describe ApiKeysController, type: :controller do

    before(:each) do
      @routes = Engine.routes
    end

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # ApiKeysController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe 'POST #create' do
      context 'with master key' do
        before(:each) do
          @master_key = ApiKey.create!(:group => :master_key)
          controller.request.headers['X-API-TOKEN'] = @master_key.api_token
        end

        context 'with valid params' do
          before(:each) do
            @valid_attributes = {:group => 'group_1'}
          end

          it 'creates a new ApiKey' do
            expect {
              post :create, @valid_attributes
            }.to change(ApiKey, :count).by(1)
          end

          it 'assigns a newly created api_key as @api_key' do
            post :create, @valid_attributes

            expect(assigns(:api_key)).to be_a(ApiKey)
            expect(assigns(:api_key)).to be_persisted
          end
        end

        context 'with invalid params' do
          before(:each) do
          end

          it 'should not change ApiKey count when group is nil' do
            expect {
              post :create, {:group => nil}
            }.to_not change(ApiKey, :count)
          end

          it 'should not change ApiKey count when group param does not exist' do
            expect {
              post :create, {}
            }.to_not change(ApiKey, :count)
          end
        end
      end

      context 'with incorrect api key' do
        before(:each) do
          @master_key = ApiKey.create!(:group => :wrong_group)
          controller.request.headers['X-API-TOKEN'] = @master_key.api_token
          @valid_attributes = {:group => 'group_1'}
        end

        it 'fails to create a new ApiKey' do
          expect {
            post :create, @valid_attributes
          }.to_not change(ApiKey, :count)

          expect(response.status).to be 403
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'with master key' do
        before(:each) do
          @master_key = ApiKey.create(:group => :master_key)
          @api_key = ApiKey.create!(:group => 'group_1')
          controller.request.headers['X-API-TOKEN'] = @master_key.api_token
        end

        it 'destroys the requested api_key with the id' do
          expect {
            delete :destroy, {:id => @api_key.to_param.to_i}
          }.to change(ApiKey, :count).by(-1)
        end

        it 'destroys the requested api_key with the api token' do
          expect {
            delete :destroy_by_access_token, {:api_token => @api_key.api_token}
          }.to change(ApiKey, :count).by(-1)
        end

        it 'does not change the ApiKey count when the key does not exist' do
          expect {
            delete :destroy_by_access_token, {:api_token => 'not_a_real_key'}
          }.not_to change(ApiKey, :count)

          expect(response).to be_success
        end
      end

      context 'with incorrect api key' do
        before(:each) do
          @master_key = ApiKey.create!(:group => :wrong_group)
          @api_key = ApiKey.create!(:group => 'group_1')
          controller.request.headers['X-API-TOKEN'] = @master_key.api_token
        end

        it 'fails to destroy the ApiKey by id' do
          expect {
            delete :destroy, {:id => @api_key.to_param.to_i}
          }.to_not change(ApiKey, :count)

          expect(response.status).to be 403
        end

        it 'fails to destroy the ApiKey by api token' do
          expect {
            delete :destroy_by_access_token, {:api_token => @api_key.api_token}
          }.to_not change(ApiKey, :count)

          expect(response.status).to be 403
        end
      end
    end
  end
end
