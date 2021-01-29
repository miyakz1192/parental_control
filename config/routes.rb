Rails.application.routes.draw do
  resources :devices
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  get "devices/:id/enable", to: "devices#enable", as: "enable"
  get "devices/:id/disable", to: "devices#disable", as: "disable"
end
