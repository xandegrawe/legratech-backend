Rails.application.routes.draw do
  namespace :api do
    resources :customers, only: [:index, :show, :create, :update, :destroy]
    resources :providers, only: [:index, :show, :create, :update, :destroy]
    resources :bank_accounts, only: [:index, :show, :create, :update, :destroy]
    
    resources :bank_invoices, only: [:index, :show, :create, :update, :destroy] do
      member do
        get 'calculate_summary' => 'bank_invoices#calculate_summary'
      end
    end


    resources :categories, only: [:index, :show, :create]
    resources :people, only: [:index, :show]
  end

  # root "articles#index"
end