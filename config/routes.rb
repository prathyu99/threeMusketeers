Rails.application.routes.draw do
  root 'home#index'
  resources :event_tickets do
    collection do
      get :booking_history
    end
  end
  resources :reviews
  resources :event_tickets
  resources :events
  resources :rooms
  resources :attendees
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :sessions, only: [:new, :create, :destroy]
  get 'profile', to: 'attendees#profile', as: :profile
  get 'signup', to: "attendees#new", as: 'signup'
  get 'login', to: "sessions#new", as: 'login'
  get 'logout', to: "sessions#destroy", as: 'logout'
  get 'booking_history', to: 'event_tickets#booking_history'
  get 'events_ticket', to: 'events#ticket_price'
  get 'event_ticket_id', to: 'event_tickets#get_event_id'
  get 'admin_search', to: 'event_tickets#admin_search'
  # For details on the DSL available within this file, see
  # Defines the root path route ("/")
  # root "articles#index"
end
