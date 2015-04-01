Slotility::Application.routes.draw do
  
  get '/pg/:name', to: 'pages#show'
  if true # TEMP Rails.env.development?  # show ability to edit only in development for now.
    get '/pages/show_admin/:id', to: 'pages#show_admin'
    resources :pages do
      get 'index_admin', on: :collection
    end
    resources :pages
  else
    resources :pages, only: [:index, :show]
  end


  if true # Rails.env.development?  # show ability to edit only in development for now.
    get '/interventions/show_admin/:id', to: 'interventions#show_admin'
    resources :interventions do
      get 'index_admin', on: :collection
    end
    resources :interventions
  else
    resources :interventions, only: [:index, :show]
  end
  
  devise_for :users

  get '/token' => 'home#token', as: :token

  resources :home, only: :index
  resources :dashboard, only: :index
  get 'dashboard/new_user' => 'dashboard#new_user'  # HACK TODO
  get 'dashboard/start_trial' => 'dashboard#start_trial'  # HACK TODO
  get 'dashboard/daily_update'  => 'dashboard#daily_update' # HACK TODO

  resources :admins, only: :index
  resources :profiles do
      post 'create_or_update', on: :collection
      get 'risk_assessment', on: :collection
      post 'track_selection', on: :collection
      get 'supplement_selection', on: :collection
      post 'supplement_selection', on: :collection
      post 'trial_selection', on: :collection
  end

  resources :logging, only: :create do
    get '/update/:id', to: 'logging#update', on: :collection
    post '/update/:id', to: 'logging#update', on: :collection
  end

  resources :reports, only: :index do
    get 'user_report', on: :collection
    get 'user_report/:id', to: 'reports#user_details', as: 'user_details', on: :collection
  end

  resources :users, only: :index do
    post 'login', on: :collection
    get 'glance', on: :collection
    get 'steps', on: :collection
    get 'introduction', on: :collection
    get 'principles', on: :collection
    post 'account', on: :member
    post 'logout', on: :member
    get 'dashboard', on: :member
    get 'profile', on: :member
    put 'update_settings', on: :member
    get 'notification', on: :member
    post 'feedback', on: :collection
    get 'policy', on: :collection
    post 'forgot_password', on: :collection
    post 'update_password', on: :collection
    get 'get_supplements', on: :collection
    post 'acknowledge_supplements', on: :collection
    get 'notification_count', on: :member
  end  

  root 'home#index'
end
