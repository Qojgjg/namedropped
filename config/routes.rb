Rails.application.routes.draw do
  require 'sidekiq/web'

  root to: 'homepage#index'

  get '/typeahead_search', to: 'searches#typeahead_search'
  get '/search', to: 'searches#main_search'

  resources :search, only: [:show]
  resources :episodes, only: [:show]

  devise_scope :user do
    get '/alerts', to: 'users#new'
    post '/alerts', to: 'users#create'
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end
end
