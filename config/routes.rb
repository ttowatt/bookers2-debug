Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "homes#top"
  get "home/about"=>"homes#about"
  get 'search', to: 'searches#search', as: 'search'

  devise_for :users
  
  resources :users, only: [:index,:show,:edit,:update] do
    member do
      post :follow, to: "relationships#create"
      delete :unfollow, to: "relationships#destroy"
      get :following
      get :followers
    end
  end

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorite, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end