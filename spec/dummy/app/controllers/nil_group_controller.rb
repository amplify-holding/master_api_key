class NilGroupController < ApplicationController
  belongs_to_api_group(nil)

  def index
    head(:ok)
  end
end
