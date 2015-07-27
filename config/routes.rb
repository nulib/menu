Menu::Application.routes.draw do

  resources :new_records do
    member do
      post  'save_xml'
      post  'publish'
    end
  end

  # resources :existing_records, except: :show do
  #   member do
  #     post  'save_xml'
  #   end
  # end

  resources :jobs

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'jobs#index'
  get 'existing_records/edit', to: 'existing_records#edit', as: :existing_records_edit
  post 'existing_records/update/' => 'existing_records#update'

  #get 'exit', to: 'sessions#destroy', as: :logout
  post 'existing_records/save_xml/:pid', to: 'existing_records#save_xml', as: :existing_records_save_xml

  #match 'images/:id/edit/publish', to: 'images#publish', as: :publish, via: [:post, :patch]


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
