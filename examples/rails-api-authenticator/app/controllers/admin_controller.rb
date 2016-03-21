class AdminController < ApplicationController

  skip_before_action  :verify_authenticity_token
  before_filter :authorize_action_filter, only: [:create]

  def index
    success_message
  end

  def create
    success_message
  end

  private

  def success_message
    render json: { message: 'Congratulations!! You are authorized!' }.to_json, status: :ok
  end
end
