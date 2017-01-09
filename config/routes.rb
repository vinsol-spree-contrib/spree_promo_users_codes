Spree::Core::Engine.routes.draw do
  # Add your extension routes here

  namespace :admin do
    resources :promotions, only: [] do
      resources :codes, except: [:edit]
    end
  end
end
