Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount WalkV1Api => "/api/v1"
  mount GrapeSwaggerRails::Engine => '/swagger'
end
