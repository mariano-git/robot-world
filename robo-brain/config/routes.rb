Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :pos
    end
  end
  namespace :api do
    namespace :v1 do
      namespace :qa do
        resources :car
      end
    end
  end
  namespace :api do
    namespace :v1 do
      resources :inventory
    end
  end
  namespace :api do
    namespace :v1 do
      namespace :factory do
        resources :inventory
      end
    end
  end
  namespace :api do
    namespace :v1 do
      namespace :factory do
        resources :car
      end
    end
  end
  namespace :api do
    namespace :v1 do
      namespace :factory do
        resources :bom
      end
    end
  end

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
