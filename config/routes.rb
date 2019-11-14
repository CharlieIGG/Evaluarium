# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  get 'users/index'
  get 'users/new'
  get 'users/edit'
  get 'users/create'
  get 'users/update'
  get 'users/destroy'
  devise_for :users
  devise_scope :user do
    authenticated :user, ->(user) { user.has_role?(:superadmin) } do
      # root to: 'evaluation_programs#index', as: :superadmin_root
      mount Sidekiq::Web => '/sidekiq'
    end
  end
  resources :users, except: %i[show]
  root to: 'landing#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
