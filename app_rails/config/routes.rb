Rails.application.routes.draw do
  resources :professionals do
    resources :appointments # CRUD new, create, edit, update, show, destroy, index
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
