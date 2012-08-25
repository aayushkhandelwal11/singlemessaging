Singlemessaging::Application.routes.draw do


  get "admin/index"

  get "sessions/new"

  get "sessions/create"

  get "sessions/destroy"

  resources :threadmessages, :except => [:edit, :update]

  resources :messages, :except => [:edit, :update]
  #match 'users/change_avatar' => 'users#change_avatar',:via => "put"
  #match.resources :users, :member => { :change_avatar => :get }
  #match '/users/change_avatar', :controller => 'users', :action => 'change_avatar', :method => 'put'
  match "/change_avatar" => "users#change_avatar", :as => "change_avatar",:via => "get"
   match "/update_picture" => "users#update_picture", :as => "update_picture",:via => "put"
  resources :users do
   #collection do
      #put "change_avatar"
    #end
     #put :change_avatar,:on => :collection
     #put :update_picture,:on => :collection,:as=>"update_picture"
     get :autocomplete_user_name,:on => :collection
  end
  
	controller :sessions do
		get 'login' => :new
		post 'login' => :create
		delete 'logout' => :destroy
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
    root :to => 'messages#index', as: 'mes' 

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
