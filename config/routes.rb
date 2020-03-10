Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/admin/sidekiq'

  root to: 'homepage#index'

  get '/typeahead_search', to: 'searches#typeahead_search'
  get '/search', to: 'searches#main_search'

  resources :search, only: [:show]
  resources :episodes, only: [:show]
end
