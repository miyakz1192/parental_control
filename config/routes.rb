Rails.application.routes.draw do
  resources :devices
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  put "devices/:id/enable", to: "devices#enable"
  put "devices/:id/disable", to: "devices#disable"
end
