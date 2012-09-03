Singlemessaging::Application.routes.draw do


 #fix: use resource as much as possible.
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  resources :threadmessages do
    get :download
  end
  
  match "/show_particular/:id" => "messages#show_particular", :as => "show_particular",:via => "get"
  match "/draft_index" => "messages#draft_index", :as => "draft_index",:via => "get"
  match "/reply" => "messages#reply", :as => "reply",:via => "get"
  match "/flag" => "messages#flag", :as => "flag",:via => "put"
  match "/outbox" => "messages#outbox", :as => "outbox",:via => "get"
  match "/edit_draft/:id" => "messages#edit_draft", :as => "edit_draft",:via => "get"
  match "/send_draft" => "messages#send_draft", :as => "send_draft",:via => "put"
  resources :messages, :except => [:edit, :update]
  
  resources :assets 
  
  match "/change_avatar" => "users#change_avatar", :as => "change_avatar",:via => "get"
  match "/update_picture" => "users#update_picture", :as => "update_picture",:via => "put"
  match "/change_notification" => "users#change_notification", :as => "change_notification",:via => "get"
  match "/update_notification" => "users#update_notification", :as => "update_notification",:via => "put"
  match "/user_verify" => "users#user_verify", :as => "user_verify",:via => "get"
  match "/send_password" => "users#send_password", :as => "send_password",:via => "get"
  resources :users do
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
    root :to => 'messages#index', as: 'inbox' 

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
