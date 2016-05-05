shared_examples_for :read_access_rights do |group_name, success_code|
  it "should return 403 (:forbidden) if the api token doesn't have read access" do
    restricted_api_key = MasterApiKey::ApiKey.create!(:group => group_name, :write_access => true)
    controller.request.headers['X-API-TOKEN'] = restricted_api_key.api_token

    @action.call

    expect(response).to have_http_status(403)
  end

  it "should return :#{success_code} if the api token doesn't have write access" do
    restricted_api_key = MasterApiKey::ApiKey.create!(:group => group_name, :read_access => true)
    controller.request.headers['X-API-TOKEN'] = restricted_api_key.api_token

    @action.call

    expect(response).to have_http_status(success_code)
  end
end

shared_examples_for :write_access_rights do |group_name, success_code|
  it "should return 403 (:forbidden) if the api token doesn't have write access" do
    restricted_api_key = MasterApiKey::ApiKey.create!(:group => group_name, :read_access=> true)
    controller.request.headers['X-API-TOKEN'] = restricted_api_key.api_token

    @action.call

    expect(response).to have_http_status(403)
  end

  it "should return :#{success_code} if the api token doesn't have read access" do
    restricted_api_key = MasterApiKey::ApiKey.create!(:group => group_name, :write_access => true)
    controller.request.headers['X-API-TOKEN'] = restricted_api_key.api_token

    @action.call

    expect(response).to have_http_status(success_code)
  end
end
