Rails.application.routes.draw do
  resources :professionals
  resources :appointments # CRUD new, create, edit, update, show, destroy, index
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
