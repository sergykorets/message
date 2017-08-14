Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :chatrooms do
  	resource :chatroom_users
  	resources :messages
  end
  root to: 'chatrooms#index'

end
