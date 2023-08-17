Rails.application.routes.draw do
  resources :articles do
    member do
      post 'comment'
      delete 'comment', to: 'articles#delete_comment'
    end
  end

  devise_for :users

  root "articles#index"
end
