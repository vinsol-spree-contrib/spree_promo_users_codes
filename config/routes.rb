Spree::Core::Engine.routes.draw do
  # Add your extension routes here

  namespace :admin do
    scope module: 'promotion' do
      resources :promotions do
        resources :codes
      end
    end
  end
end
