Rails.application.routes.draw do
  post '/signup', to: 'auth#signup'
  post '/login', to: 'auth#login'

  resources :tasks
  resources :users, only: [] do
    member do
      get 'task_stats', to: 'users#task_stats'
    end
  end
  
  namespace :admin do
    get 'login', to: 'sessions#new', as: 'login'
    post 'login', to: 'sessions#create'
    post 'logout', to: 'sessions#destroy', as: 'logout'

    resources :tasks
    root to: 'tasks#index'
  end
end
