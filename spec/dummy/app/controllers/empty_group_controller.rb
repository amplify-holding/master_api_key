class EmptyGroupController < ApplicationController
  belongs_to_api_group('')

  def index
    head(:ok)
  end
end
