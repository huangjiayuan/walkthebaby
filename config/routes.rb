Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount WalkV1Api => "/api/v1"
  mount GrapeSwaggerRails::Engine => '/swagger'

  resources :users
  resources :homes
  resources :live_lists do
    collection do
      get :sync_push_pull
      get :sync_info
      get :save_mpfour
      get :live_show
    end
  end

end
