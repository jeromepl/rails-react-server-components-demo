Rails.application.routes.draw do
  root to: "pages#main"

  resources :notes, only: [:index, :create, :update, :destroy]
end
