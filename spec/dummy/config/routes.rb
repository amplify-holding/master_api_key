Rails.application.routes.draw do
  mount MasterApiKey::Engine => '/master_api_key'

  get 'nil_group', to: 'nil_group#index'
  get 'empty_group', to: 'empty_group#index'
end
