Rails.application.routes.draw do
  get '/rsc', to: 'rsc#show'
  post '/notes', to: 'notes#create'
end
