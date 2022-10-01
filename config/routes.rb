Rails.application.routes.draw do
  mount API => '/'
  root to: 'pages#home'
end
