Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'home#index'
  resources :promotions , only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    member do
      post 'generate_coupons'
      post 'approve'
      # get 'search'
    end
    collection do
      get 'search'
    end
  end
  # get 'promotions/search', to: 'promotions#search'

  resources :categories, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :coupons, only: [] do
    post 'inactivate', on: :member    
  end

  get 'search', to: 'home#search'

end
