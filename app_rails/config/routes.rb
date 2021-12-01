Rails.application.routes.draw do

  resources :users_admin, :controller => 'users'
  devise_for :users
  root to: 'professionals#index'
# CRUD new, create, edit, update, show, destroy, index
  resources :professionals do
    resources :appointments do
      collection do
        delete 'cancel-all', action: 'cancel_all'
      end
    end
  end
  
  get 'appointments_grid', to: 'presentations#new_export', as: 'appointments_grid'
  post 'export_appointments', to: 'presentations#export_appointments', as: 'export_appointments'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
