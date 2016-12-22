Rails.application.routes.draw do
  resources :custom_fields
  get '/result_sets/edit' => 'result_sets#edit'
  post '/result_sets/edit' => 'result_sets#edit'
  resources :statuses

  resources :products do
    resources :plans
  end


  resources :plans do
    resources :runs
  end

  resources :runs do
    resources :result_sets
  end

  resources :result_sets do
    resources :results
  end

  root 'products#index'
  get 'users/sign_in', to: redirect('/login')

  devise_for :users

  devise_scope :user do
    get '/login' => 'devise/sessions#new'
    get '/settings/admin' => 'devise/registrations#edit'
  end

  get '/settings/status_settings_title' => 'statuses#index'
  get '/settings/status_settings_title/:id/edit' => 'statuses#edit'
  get '/settings/products' => 'products#edit'
  get '/settings/custom_fields' => 'custom_fields#index'
  post '/settings/status_settings_title/:id' => 'statuses#disable'
  post '/settings/custom_fields' => 'custom_fields#create'
  delete '/settings/custom_fields/delete/:id' => 'custom_fields#delete_custom_field'

  resources :statuses, path: '/settings/status_settings'

  get '/settings/tokens' => 'settings#tokens'


  #---------------------------API------------------------------#
  # Products
  get 'api/products/get_products' => 'products#get_products'
  get 'api/products/get_products_by_param' => 'products#get_products_by_param'
  get 'api/products/get_all_plans_by_product' => 'products#get_all_plans_by_product'
  post 'api/products/add_new_product' => 'products#create'
  post 'api/products/update_product' => 'products#update'
  post 'api/products/delete_product' => 'products#destroy'
  # Plans
  get 'api/plans/get_plans' => 'plans#get_plans'
  get 'api/plans/get_plans_by_param' => 'plans#get_plans_by_param'
  get 'api/plans/get_all_runs_by_plan' => 'plans#get_all_runs_by_plan'
  post 'api/plans/add_new_plan' => 'plans#create'
  post 'api/plans/update_plan' => 'plans#update'
  post 'api/plans/delete_plan' => 'plans#destroy'
  # Runs
  get 'api/runs/get_all_runs' => 'runs#get_all_runs'
  get 'api/runs/get_runs_by_param' => 'runs#get_runs_by_param'
  get 'api/runs/get_all_result_sets_by_run' => 'runs#get_all_result_sets_by_run'
  post 'api/runs/add_new_run' => 'runs#create'
  post 'api/runs/update_run' => 'runs#update'
  post 'api/runs/delete_run' => 'runs#destroy'
  # ResultSet
  get 'api/result_sets/get_all_result_sets' => 'result_sets#get_all_result_sets'
  get 'api/result_sets/get_result_sets_by_param' => 'result_sets#get_result_sets_by_param'
  post 'api/result_sets/add_new_result_set' => 'result_sets#create'
  post 'api/result_sets/update_result_set' => 'result_sets#update'
  post 'api/result_sets/delete_result_set' => 'result_sets#destroy'
  # Result
  get 'api/results/get_all_results' => 'results#get_all_results'
  get 'api/results/get_result_by_param' => 'results#get_result_by_param'
  post 'api/results/add_new_result' => 'results#create'
  post 'api/results/update_result' => 'results#update'
  post 'api/results/delete_result' => 'results#destroy'
  # Status
  get 'api/statuses/get_all_statuses' => 'statuses#get_all_statuses'
  get 'api/statuses/get_statuses_by_param' => 'statuses#get_statuses_by_param'
  get 'api/statuses/status_exist' => 'statuses#status_exist?'
  post 'api/statuses/status_exist' => 'statuses#status_exist?'
  post 'api/statuses/add_new_status' => 'statuses#create'
  post 'api/statuses/update_status' => 'statuses#update'
  # post 'api/statuses/delete_status' => 'statuses#destroy'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
