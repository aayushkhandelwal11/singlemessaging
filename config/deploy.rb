require "bundler/capistrano"
# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

default_run_options[:pty] = true
set :application, "singlemessaging"
set :deploy_to, "/var/www/#{application}"

set :repository,  "git@github.com:aayushkhandelwal11/singlemessaging.git"

set :scm, :git
set :user, "aayush"
set :use_sudo, false

set :branch, "master"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "50.56.70.107"                      	# Your HTTP server, Apache/etc
role :app, "50.56.70.107"                      	# This may be the same as your `Web` server
role :db,  "50.56.70.107", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
 [:start, :stop].each do |t|
   desc "#{t} task is a no-op with mod_rails"
   task t, :roles => :app do ; end
 end
 
 desc "Restarting mod_rails with restart.txt"
 task :restart, :roles => :app, :except => { :no_release => true } do
   run "touch #{File.join(current_path,'tmp','restart.txt')}"
 end

 after :symlink, :after_symlink
 
 task :after_symlink, :roles => :app do
   run "cp #{shared_path}/config/database.yml #{current_path}/config/database.yml"
   run "bundle install"
 end
 
 desc "Deploy with migrations"
 task :long do
   transaction do
 	update_code
 	web.disable
 	symlink
 	migrate
   end

   restart
   web.enable
   cleanup
 end

 desc "Run cleanup after long_deploy"
 task :after_deploy do
   cleanup
 end
end
