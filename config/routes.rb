Rails.application.routes.draw do
  root to: 'homepage#index'
  resource :search, only: [:show]
end
