Rails.application.routes.draw do

  get 'users/show'
  get 'users/edit'
  get 'users/update'
  devise_for :users
  root to: 'pages#home'
  resources :lessons, only: [:index, :show, :new, :create] do
    resources :participations, only: :create
  end
  resources :users do
    resources :participants, only: [:show, :edit]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
