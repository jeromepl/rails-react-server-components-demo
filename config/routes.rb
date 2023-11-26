Rails.application.routes.draw do
  root to: "pages#main"

  get '/rsc', to: 'rsc#show'

  post '/notes', to: 'notes#create'
  put '/notes/:id', to: 'notes#update'
  delete '/notes/:note_id', to: 'notes#delete'
end
