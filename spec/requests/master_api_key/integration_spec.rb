require 'rails_helper'

RSpec.describe 'Integration', type: :request do
  describe 'error cases' do
    it 'should raise error with nil group configuration' do
      expect {
        get '/nil_group'
      }.to raise_error(ArgumentError)
    end

    it 'should raise error with empty group configuration' do
      expect {
        get '/empty_group'
      }.to raise_error(ArgumentError)
    end
  end
end