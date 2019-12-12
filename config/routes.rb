Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :papas_math_game, only: [:index]
    end
  end
end
