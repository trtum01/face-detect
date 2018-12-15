Rails.application.routes.draw do
  post '/face' => 'face#index'
  get 'face' => 'face#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'face#index'
end