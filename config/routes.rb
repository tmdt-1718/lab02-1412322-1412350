Rails.application.routes.draw do
  root 'users#home'
  get '/new_messages', to: 'messages#newmessages'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :conversations, only: [:create, :index, :show] do
    member do
      post :close
    end
    resources :messages, only: [:create]
  end
end
