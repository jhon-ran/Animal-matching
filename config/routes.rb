Rails.application.routes.draw do
  root to: 'static_pages#home'
  devise_for :users
  resource :users, :except => [:new, :create, :index, :destroy], path: "mon_compte"

  resources :pets do
    resources :likes
    member do
      delete :delete_photo
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
