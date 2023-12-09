Rails.application.routes.draw do

  root to: "tasks#index"



  resources :tasks do
    member do
      post 'start'
      patch 'stop'
      post 'next', constraints: { method: 'POST' }
      get 'next'
    end

    collection do
      delete 'destroy_all'
    end

  end


end
