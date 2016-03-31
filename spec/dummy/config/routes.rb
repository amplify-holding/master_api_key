Rails.application.routes.draw do
  mount MasterApiKey::Engine => '/master_api_key'
end
