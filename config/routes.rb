
MasterApiKey::Engine.routes.draw do
  delete '/api_keys', to: 'api_keys#destroy_by_access_token'
  resources :api_keys, only: [:create, :destroy]
end
