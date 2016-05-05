shared_examples_for :group_authorizations do |group_name, success_code|
  it "should return #{success_code} when the api group '#{group_name}' is used" do
    unrestricted_api_key = MasterApiKey::ApiKey.create!(group: group_name, read_access:true, write_access:true)
    controller.request.headers['X-API-TOKEN'] = unrestricted_api_key.api_token

    @action.call

    expect(response).to have_http_status(success_code)
  end

  it "should return 403 when the api group '#{group_name}' is not used" do
    restricted_api_key = MasterApiKey::ApiKey.create!(:group => "#{group_name}_wrong", read_access:true, write_access:true)
    controller.request.headers['X-API-TOKEN'] = restricted_api_key.api_token

    @action.call

    expect(response).to have_http_status(:forbidden)
  end
end

shared_examples_for :api_authorizations do |group_name, success_code|
  it "should return #{success_code} when a valid api token is used" do
    unrestricted_api_key = MasterApiKey::ApiKey.create!(group: group_name, read_access:true, write_access:true)
    controller.request.headers['X-API-TOKEN'] = unrestricted_api_key.api_token

    @action.call

    expect(response).to have_http_status(success_code)
  end

  it 'should return 401 when an invalid api token is not used' do
    unrestricted_api_key = MasterApiKey::ApiKey.create!(group: group_name, read_access:true, write_access:true)
    controller.request.headers['X-API-TOKEN'] = "#{unrestricted_api_key.api_token}_invalid"

    @action.call

    expect(response).to have_http_status(:unauthorized)
  end
end