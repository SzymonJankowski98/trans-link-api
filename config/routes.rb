# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: :all

  namespace :v1, defaults: { format: :json } do
    devise_scope :user do
      resource :users,
               only: %i[create update destroy],
               controller: "users/registrations",
               as: :user_registration

      resource :users, only: [], controller: "users/sessions", as: :user_session do
        post "/sign_in", action: :create
        post "/sign_out", action: :destroy
      end
    end

    resources :learning_texts, only: %i[index create]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
