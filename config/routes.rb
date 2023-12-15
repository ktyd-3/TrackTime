Rails.application.routes.draw do

  root to: "tasks#index"

  resources :tasks do
    member do
      post 'start'
      patch 'stop'
      post 'next'
      get 'next'
      get 'start'
      get 'stop'
      get 'track'
      get 'destroy'
    end

    collection do
      get 'track'
    end

    delete 'destroy', on: :member

  end

end
