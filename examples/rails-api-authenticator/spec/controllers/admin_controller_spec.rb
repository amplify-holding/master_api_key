require 'rails_helper'

describe AdminController, :type => :controller do
  describe 'GET #index' do
    it 'responds successfully with an HTTP 200 status code' do
      get :index

      expect(response.status).to eq(200)
    end
  end

  describe 'POST #create' do
    before(:each) do
      @api_header = 'X-API-TOKEN'
      @api_token = 'token_1'
    end

    context 'api token was not set' do
      it 'should respond with a 401 if the api key was not set' do
        post :create

        expect(response.status).to eq(401)
      end
    end

    context 'api token was set' do
      before(:each) do
        request.headers[@api_header] = @api_token
      end

      it 'should respond with a 401 if the api key was not valid indicating the key was not authenticated' do
        post :create

        expect(response.status).to eq(401)
      end

      it 'should respond with a 200 if the api key is valid indicating the key was authenticated' do
        ApiKey.create!(api_token: @api_token, group:'fake_group')

        post :create

        expect(response.status).to eq(200)
      end
    end
  end
end

