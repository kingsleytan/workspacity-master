Rails.application.routes.draw do

  mount ActionCable.server => '/cable'

  root to: 'landing#index'
  get :about, to: 'static_pages#about'
  resources :topics, except: [:show] do
    resources :posts do
      resources :comments
    end
  end
  resources :users, only: [:new, :edit, :create, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  resources :my_resources, :concerns => :paginatable

  post :upvote, to: 'votes#upvote'
  post :downvote, to: 'votes#downvote'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
