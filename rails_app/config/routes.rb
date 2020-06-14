# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  root to: "home#index"
  # ...

  resources :announcements, only: [:index]
  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  post '/', to: "home#enqueue"
end
