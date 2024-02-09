Rails.application.routes.draw do
  # get 'events/index'

  root to: "events#index"

  devise_for :users

  get 'events/event_a', to: 'events#event_a', as: 'create_event_a'
  get 'events/event_b', to: 'events#event_b', as: 'create_event_b'

  post 'events/event_a', to: 'events#event_a'
  post 'events/event_b', to: 'events#event_b'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
