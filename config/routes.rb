Singlemessaging::Application.routes.draw do
  scope "(:locale)", :locale => /en|hi/ do
    resources :oauths, :only => [:destroy, :index] do
       get :generate, :on => :collection
    end

    match '/auth/:provider/callback' => 'authentication#create'
    get "authentication/index"
    get "authentication/fill_email"
    post "authentication/change_email"
    get "authentication/create"

    get "authentication/destroy"
   # get "sessions/new"
    get "sessions/create"
    #get "sessions/destroy"
    #get "sessions/set_locale"
    get "sessions/faq"


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

    root :to => 'sessions#new' 
  end
  match '/:locale' => 'sessions#new' , :as => "/login"

end
