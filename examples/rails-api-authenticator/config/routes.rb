ApiAuthenticator::Application.routes.draw do

  resources :api_key, only: [:create, :destroy]
  delete '/api_key', to: 'api_key#destroy_by_access_token'

  resources :admin

end
