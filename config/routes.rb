Rails.application.routes.draw do
  # Add your extension routes here
    namespace :admin do
      resources :cities, :only => :index
      resources :countries do
        resources :states do
          resources :cities do
          end
        end
      end
    end
end
