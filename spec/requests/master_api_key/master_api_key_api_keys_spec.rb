require 'rails_helper'

RSpec.describe 'ApiKeys', type: :request do
  describe 'POST /master_api_key/api_keys' do
    it 'should return 200 with properly formatted request' do
      post '/master_api_key/api_keys', :group => 'group_1'
      json_object = JSON.parse response.body

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq 'application/json'

      hash_verifier = {'group' => 'group_1'}
      expect(json_object).to include 'apiKey'
      expect(json_object['apiKey']).to include hash_verifier
      expect(json_object['apiKey']).to include 'id', 'api_token'
      expect(json_object['apiKey']['id']).to be_an(Integer)
      expect(json_object['apiKey']['api_token']).to be_a(String)
    end

    it 'should return 400 with nil group' do
      post '/master_api_key/api_keys', :group => nil
      expect(response).to have_http_status(400)
    end

    it 'should return 400 if group param is missing' do
      post '/master_api_key/api_keys'
      expect(response).to have_http_status(400)
    end
  end

  describe 'DELETE /master_api_key/api_keys/#id' do

    it 'should return 200 with properly formatted request' do
      post '/master_api_key/api_keys', :group => 'group_1'
      expect(response).to have_http_status(200)

      json_object = JSON.parse response.body

      id = json_object['apiKey']['id']

      delete "/master_api_key/api_keys/#{id}"
      expect(response).to have_http_status(200)
    end

    it 'should return 200 when there is nothing to remove' do
      delete '/master_api_key/api_keys/100'
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE /master_api_key/api_keys' do

    it 'should return 200 with properly formatted request' do
      post '/master_api_key/api_keys', :group => 'group_1'
      expect(response).to have_http_status(200)

      json_object = JSON.parse response.body

      api_token = json_object['apiKey']['api_token']

      delete '/master_api_key/api_keys', :api_token => api_token
      expect(response).to have_http_status(200)
    end

    it 'should return 200 when there is nothing to remove' do
      delete '/master_api_key/api_keys' , :api_token => 'nothing_to_see_here'
      expect(response).to have_http_status(200)
    end

    it 'should return 400 when the api_token is nil' do
      delete '/master_api_key/api_keys' , :api_token => nil
      expect(response).to have_http_status(400)
    end

    it 'should return 400 when the api_token param is missing' do
      delete '/master_api_key/api_keys'
      expect(response).to have_http_status(400)
    end
  end
end
