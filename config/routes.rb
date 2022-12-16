Rails.application.routes.draw do
  devise_for :users
  mount Rswag::Ui::Engine => '/swagger'
  mount Rswag::Api::Engine => '/swagger'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  authenticate :user do
    match '/delayed_job' => DelayedJobWeb, :anchor => false, :via => %i[get post]
    mount Avo::Engine, at: Avo.configuration.root_path
    get '/', to: 'dashboard#index'
    resources :payments
    resources :texts
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: redirect('/avo')
  scope module: 'api' do
    # Payments
    post '/api/payments', to: 'payments#create'
    get '/api/payments', to: 'payments#index'

    # Texts
    post '/api/texts', to: 'texts#create'
    get '/api/texts', to: 'texts#index'

    # Charts
    get '/api/charts/party_report', to: 'charts#party_report'
    get '/api/login', to: 'o_auth#login', as: :identity_login, allow_other_host: true
    get '/oauth/callback', to: 'o_auth#oauth_callback'
  end
end
