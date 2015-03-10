Coincooler::Application.routes.draw do

  resources :uploads
 	resources :freezers, only: [:new, :create, :show]
 	resources :inspectors, only: [:new, :create, :addresses, :private_keys]

  root                                to: 'static#home'

  match "/home",                      to: 'static#home',              via: :get
  match "/dieharder",                 to: 'static#dieharder',         via: :get 
 
  match "/freeze",  				          to: 'freezers#new',   					via: :get
  match "/new_keys",                  to: 'freezers#show',        		via: :get
  match	"/download",				          to: 'freezers#download',				via: :get
  match "/download_row",              to: 'inspectors#download',      via: :get
  match "/old_inspect",	              to: 'inspectors#new',           via: :get
  match "/old_inspect_addresses",     to: 'inspectors#addresses',     via: :get
  match "/old_inspect_keys",          to: 'inspectors#show',          via: :get

  match "/uploads",                   to: 'uploads#index',            via: :get
  match "/inspect",                   to: 'uploads#inspect',          via: :post
  match "/inspect_keys",              to: 'uploads#keys',             via: :get
  match "/inspect_addresses",         to: 'uploads#addresses',        via: :get
  
end

