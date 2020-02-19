class ApplicationController < ActionController::Base
  if Rails.env == 'production'
    http_basic_authenticate_with name: ENV['BASIC_AUTH_USER'], password: ENV['BASIC_AUTH_PASSWORD']
  end
end
