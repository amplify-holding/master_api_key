require 'action_controller/metal/head'
require 'security/api_gatekeeper'
require 'support/api_key'

describe Security::ApiGatekeeper, 'Basic Authorization' do
  class BasicController
    include Security::ApiGatekeeper
    include ActionController::Head

    def index
      authorize_action do
        head(:ok)
      end
    end

    def request
      @request
    end

    def set_request(request)
      @request = request
    end
  end

  before(:each) do
    @controller = BasicController.new
    request = double('request')
    headers = {}
    allow(request).to receive(:headers).and_return(headers)
    @controller.set_request(request)
  end

  context 'Without API TOKEN' do
    it "should return 401 (:unauthorized) if 'X-API-TOKEN' isn't available" do
      expect(@controller).to receive(:on_authentication_failure)

      @controller.index
    end

    it 'should render a response as unauthorized by default' do
      expect(@controller).to receive(:head).with(:unauthorized)

      @controller.index
    end
  end

  context 'With API Token' do
    before(:each) do
      @api_token = 'random_api_token'
      @controller.request.headers['X-API-TOKEN'] = @api_token
    end

    it "should return 401 (:unauthorized) if the token can't be authenticated" do
      expect(ApiKey).to receive(:exists?).with(api_token: @api_token).and_return(false)
      expect(@controller).to receive(:on_authentication_failure)

      @controller.index
    end

    it "should return 403 (:forbidden) if the api token isn't authorized to access the group" do
      expect(ApiKey).to receive(:exists?).with(api_token: @api_token).and_return(true)
      expect(@controller).to receive(:on_forbidden_request).and_call_original
      expect(@controller).to receive(:head).with(:forbidden)

      @controller.index
    end

    it 'should return 200 if the token is authenticated and authorized to access the controller' do
      expect(ApiKey).to receive(:exists?).with(api_token: @api_token).and_return(true)
      expect(@controller).to receive(:head).with(:ok)

      @controller.index
    end
  end
end
