Rails.application.routes.draw do
  root 'users#home'
  get '/new_messages', to: 'messages#newmessages'
  get '/inboxs', to: 'email_messages#inbox'
  get '/sentmails', to: 'email_messages#sentmail'  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    :omniauth_callbacks => "users/omniauth_callbacks"
  }
  resources :conversations, only: [:create, :index, :show] do
    member do
      post :close
    end
    resources :messages, only: [:create]
  end
  resources :users, only: [:index] do
    resources :relationships, only: [:create, :update, :destroy]
    resources :email_messages, only: [:create, :new]
  end
end
