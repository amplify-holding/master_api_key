require 'rails_helper'
require 'support/access_shared_examples'
require 'support/auth_shared_examples'

module MasterApiKey
  RSpec.describe ApiKeysController, type: :controller do
    before(:each) do
      @routes = Engine.routes
    end

    describe 'GET #index' do
      context 'with master key' do
        before(:each) do
          @master_key = ApiKey.create!(:group => :master_key, :read_access => true, :write_access => true)
          controller.request.headers['X-API-TOKEN'] = @master_key.api_token
        end

        context 'with valid params' do
          before(:each) do
            @group_name = 'group_1'
            @api_key = ApiKey.create!(:group => @group_name, write_access: true)
            @valid_attributes = {:api_token => @api_key.api_token}
          end

          it 'should return valid json of api_key' do
            get :index, @valid_attributes

            json_object = (JSON.parse response.body).with_indifferent_access
            expect(json_object[:api_key][:api_token]).to eq @api_key.api_token
            expect(json_object[:api_key][:group]).to eq @group_name
            expect(json_object[:api_key][:read_access]).to be_falsey
            expect(json_object[:api_key][:write_access]).to be_truthy
          end

          it "should return 404 when the key doesn't exist" do
            get :index, @valid_attributes.merge(:api_token => 'invalid_token')

            expect(response).to have_http_status(404)
          end

          context 'for access rights' do
            before(:each) do
              @action = lambda { get :index, @valid_attributes }
            end

            include_examples :read_access_rights, :master_key, :ok
          end

          context 'for group authorizations' do
            before(:each) do
              @api_key = ApiKey.create!(:group => @group_name)
              @action = lambda { get :index, @valid_attributes }
            end

            include_examples :group_authorizations, :master_key, :ok
          end

          context 'for api authentication' do
            before(:each) do
              @api_key = ApiKey.create!(:group => @group_name)
              @action = lambda { get :index, @valid_attributes }
            end

            include_examples :api_authorizations, :master_key, :ok
          end
        end

        context 'with invalid params' do
          it "should raise missing param exception when the required param api_token isn't one of the params" do
            get :index, {:wrong_param => 'invalid_token'}

            expect(response).to have_http_status(400)
          end
        end
      end
    end

    describe 'POST #create' do
      context 'with master key' do
        before(:each) do
          @master_key = ApiKey.create!(:group => :master_key, :read_access => true, :write_access => true)
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

          it 'assigns a new api key with default read/write access' do
            post :create, @valid_attributes

            json_object = (JSON.parse response.body).with_indifferent_access
            created_key = ApiKey.find_by_api_token(json_object[:api_key][:api_token])

            expect(created_key.group).to eq(@valid_attributes[:group])
            expect(created_key.read_access).to be_falsey
            expect(created_key.write_access).to be_falsey
          end

          it 'assigns a new api key with read/write access' do
            post :create, @valid_attributes.merge(authorizations:{ read_access: true, write_access: true })

            json_object = (JSON.parse response.body).with_indifferent_access
            created_key = ApiKey.find_by_api_token(json_object[:api_key][:api_token])

            expect(created_key.group).to eq(@valid_attributes[:group])
            expect(created_key.read_access).to be_truthy
            expect(created_key.write_access).to be_truthy
          end

          context 'for group authorizations' do
            before(:each) do
              @api_key = ApiKey.create!(:group => 'group_1')
              @action = lambda { post :create, @valid_attributes }
            end

            include_examples :group_authorizations, :master_key, :created
          end

          context 'for access rights' do
            before(:each) do
              @action = lambda { post :create, @valid_attributes }
            end

            include_examples :write_access_rights, :master_key, :created
          end

          context 'for api authentication' do
            before(:each) do
              @action = lambda { post :create, @valid_attributes }
            end

            include_examples :api_authorizations, :master_key, :created
          end
        end

        context 'with invalid params' do
          before(:each) do
          end

          it 'should not change ApiKey count when group is nil' do
            expect {
              post :create, {:group => nil}
            }.to_not change(ApiKey, :count)

            expect(response).to have_http_status(400)
          end

          it 'should not change ApiKey count when group param does not exist' do
            expect {
              post :create, {}
            }.to_not change(ApiKey, :count)

            expect(response).to have_http_status(400)
          end

          it "should not change ApiKey count when read param isn't a boolean" do
            expect {
              post :create, {:group => 'group_name', authorizations: { read_access: 'wrong type' }}
            }.to_not change(ApiKey, :count)

            expect(response).to have_http_status(400)
          end

          it "should not change ApiKey count when write param isn't a boolean" do
            expect {
              post :create, {:group => 'group_name', authorizations: { write_access: 'wrong type'}}
            }.to_not change(ApiKey, :count)

            expect(response).to have_http_status(400)
          end
        end
      end
    end

    describe 'PATCH #update' do
      context 'with master key' do
        before(:each) do
          @master_key = ApiKey.create!(:group => :master_key, :read_access => true, :write_access => true)
          controller.request.headers['X-API-TOKEN'] = @master_key.api_token
        end

        context 'with valid params' do
          before(:each) do
            @api_key = ApiKey.create!(:group => :group_1)
            @valid_attributes = { api_token: @api_key.api_token, authorizations: { read_access:true }}
          end

          it 'should update the api key so read access is false and write access is true' do
            patch :update_by_access_token, @valid_attributes.merge(authorizations: { read_access:false, write_access:true })

            json_object = (JSON.parse response.body).with_indifferent_access
            updated_key = ApiKey.find_by_api_token(json_object[:api_key][:api_token])

            expect(updated_key.read_access).to be_falsey
            expect(updated_key.write_access).to be_truthy
          end

          it 'should not update the api key group' do
            patch :update_by_access_token,  @valid_attributes.merge({:group => :group_2, authorizations:{read_access:true}})

            json_object = (JSON.parse response.body).with_indifferent_access
            updated_key = ApiKey.find_by_api_token(json_object[:api_key][:api_token])

            expect(updated_key.group).to eq('group_1')
            expect(updated_key.read_access).to be_truthy
            expect(updated_key.write_access).to be_falsey
          end

          context 'for group authorizations' do
            before(:each) do
              @action = lambda { patch :update_by_access_token, @valid_attributes }
            end

            include_examples :group_authorizations, :master_key, :ok
          end

          context 'for access rights' do
            before(:each) do
              @action = lambda { patch :update_by_access_token, @valid_attributes }
            end

            include_examples :write_access_rights, :master_key, :ok
          end

          context 'for api authentication' do
            before(:each) do
              @action = lambda { patch :update_by_access_token, @valid_attributes }
            end

            include_examples :api_authorizations, :master_key, :ok
          end
        end

        context 'with invalid params' do
          it 'should return 400 if there are no authorizations' do
            patch :update_by_access_token, { authorizations:{} }

            expect(response).to have_http_status(400)
          end

          it "should return 400 if the authorizations json doesn't exist" do
            patch :update_by_access_token, {}

            expect(response).to have_http_status(400)
          end

          it "should not change ApiKey count when read param isn't a boolean" do
            expect {
              patch :update_by_access_token, {authorizations: { read_access: 'wrong type' }}
            }.to_not change(ApiKey, :count)

            expect(response).to have_http_status(400)
          end

          it "should not change ApiKey count when write param isn't a boolean" do
            expect {
              patch :update_by_access_token, {authorizations: { write_access: 'wrong type'}}
            }.to_not change(ApiKey, :count)

            expect(response).to have_http_status(400)
          end
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'with master key' do
        before(:each) do
          @master_key = ApiKey.create(:group => :master_key, :read_access => true, :write_access => true)
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

        context 'for access rights for removal by id' do
          before(:each) do
            @action = lambda { delete :destroy, {id: @api_key.to_param.to_i} }
          end

          include_examples :write_access_rights, :master_key, :ok
        end

        context 'for access rights for removal by token' do
          before(:each) do
            @action = lambda { delete :destroy_by_access_token, {api_token: @api_key.api_token} }
          end

          include_examples :write_access_rights, :master_key, :ok
        end
      end

      context 'for group authorizations' do
        before(:each) do
          @api_key = ApiKey.create!(:group => 'group_1')
        end

        context 'with delete by id' do
          before(:each) do
            @action = lambda { delete :destroy, {:id => @api_key.to_param.to_i} }
          end
          include_examples :group_authorizations, :master_key, :ok

        end

        context 'with delete by api token' do
          before(:each) do
            @action = lambda { delete :destroy_by_access_token, {:api_token => @api_key.api_token} }
          end

          include_examples :group_authorizations, :master_key, :ok
        end
      end

      context 'for api authorizations' do
        before(:each) do
          @api_key = ApiKey.create!(:group => 'group_1')
        end

        context 'with delete by id' do
          before(:each) do
            @action = lambda { delete :destroy, {:id => @api_key.to_param.to_i} }
          end

          include_examples :api_authorizations, :master_key, :ok
        end

        context 'with delete by api token' do
          before(:each) do
            @action = lambda { delete :destroy_by_access_token, {:api_token => @api_key.api_token} }
          end

          include_examples :api_authorizations, :master_key, :ok
        end
      end
    end
  end
end
