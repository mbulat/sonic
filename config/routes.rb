Sonic::Engine.routes.draw do
  root :to => "results#index"

  resources :results
end
