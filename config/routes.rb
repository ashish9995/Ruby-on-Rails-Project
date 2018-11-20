Rails.application.routes.draw do
  root :to => "login#new"
  resources :inquiries do
    member do

    end
  end
  resources :houses
  resources :househunters
  resources :realtors
  resources :companies
  resources :users

  get    '/login',            to: 'login#new'
  post   '/login',            to: 'login#create'
  get    '/logout',           to: 'login#destroy'
  get    '/rel_houses',       to: 'houses#realtorhouses'
  post   '/house_interested', to: 'houses#interested'
  patch   '/house_interested', to: 'houses#interested'
  patch   '/house_not_interested', to: 'houses#not_interested'
  get '/inquiry/new/:id', to: 'inquiries#new', as: :test
  get    '/addimage/:id',  to: 'houses#addimages'
  get '/househunter_inquiries/:id', to: 'inquiries#index', as: :househunter_inquiries
  get     '/input', to: "househunters#input"
  get     '/gotosearch', to:"househunters#search"
  get   '/potential',to: "realtors#potential"
  get    '/admin',            to: 'admin#show', as: :admin
  get     '/edit/admin',      to: 'admin#edit'
  get     '/rswitch',         to: 'realtors#switch'
  get     '/hswitch',         to: 'househunters#switch'
  get     'glogin',           to: redirect('/auth/google_oauth2'), as: 'glogin'
  get     'auth/google_oauth2/callback', to: 'realtors#gcreate', as: 'gcreate'
end
