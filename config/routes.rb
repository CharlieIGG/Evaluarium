# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: 'users/invitations' }
  devise_scope :user do
    authenticated :user, ->(user) { user.has_role?(:superadmin) } do
      # root to: 'some_controller#index', as: :superadmin_root
      mount Sidekiq::Web => '/sidekiq'
    end
  end
  resources :users, except: %i[show]
  resources :evaluation_criteria, except: %i[show]

  root to: 'evaluation_criteria#index'
  get 'landing', to: 'landing#index'
  get 'configuration', to: 'evaluation_criteria#index', as: :configuration
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
