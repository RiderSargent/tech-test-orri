Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'github_users#index'

  resources :github_users, only: %i[index show]
end
