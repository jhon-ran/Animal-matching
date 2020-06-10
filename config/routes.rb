Rails.application.routes.draw do
  resources :pets do
    resources :likes
  end

  devise_for :users
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :pets do
    member do
      delete "delete_photo/:photo_id", action: :delete_photo
    end
  end
end
