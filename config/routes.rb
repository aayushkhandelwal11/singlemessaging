Singlemessaging::Application.routes.draw do

  match '/auth/:provider/callback' => 'authentication#create'
  get "authentication/index"
  get "authentication/fill_email"
  post "authentication/change_email"
  get "authentication/create"

  get "authentication/destroy"
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"

  match "/inbox" => "messages#inbox", :as =>"inbox", :via =>"get"
  match "/reply" => "messages#reply", :as =>"reply", :via =>"post"
  resources :messages, :except => [ :update,:index] do
    member do
      get :downloads
    end
    collection do
      get 'destroy' => :destroy
      put :index_delete
      put :show_delete
      get :drafts
      get :outbox
      put :flag
      put :send_draft  
    end 
  end 

  resources :users, :except => [:destroy, :show, :index] do
     get :autocomplete_user_name, :on => :collection
    collection do   
      get :change_time_zone 
      put :update_time_zone 
      get :change_avatar 
      put :update_picture
      get :change_notification 
      put :update_notification
      get :user_verify 
      get :send_password
    end 
  end
  
	controller :sessions do
		get 'login' => :new
		post 'login' => :create
		get 'logout' => :destroy
	end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
    root :to => 'sessions#new' 

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
