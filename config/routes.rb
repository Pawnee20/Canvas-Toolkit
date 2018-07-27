Rails.application.routes.draw do
  resources :imports, :only => [:index, :new, :create]
  get 'imports/success' => 'imports#success', as: :success
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
