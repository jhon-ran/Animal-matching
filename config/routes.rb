Rails.application.routes.draw do
  root to: 'static_pages#home'
  devise_for :users, path: "mon_compte"
  resource :users, :except => [:new, :create, :index, :destroy], path: "mon_profil"
 
  resources :pets, path: "animaux" do
    resources :likes
    resources :tags, :except => [:edit, :update]
    member do
      delete :delete_photo
    end
  end
  get '/whispaw', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
end
