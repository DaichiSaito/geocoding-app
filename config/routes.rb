Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root "static_pages#home"
  
  resources 'static_pages', only: :index do
    # collection { post :import }
    collection do
      post :import
      get 'csv_output'
    end
  end
end
