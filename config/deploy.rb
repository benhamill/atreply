set :application, "atreply"
set :repository,  "git://github.com/BenHamill/atreply.git"
set :deploy_to, "~/apps/#{application}"

set :scm, :git
default_run_options[:pty] = true
set :deploy_via, :remote_cache
set :branch, 'master'

#role :app, "your app-server here"
#role :web, "your web-server here"
#role :db,  "your db-server here", :primary => true
server 'atreply.benhamill.com', :app, :web, :db, :primary => true

set :user, 'hamillbd'
set :use_sudo, false

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

desc 'Creates the production twitter_user.yml up.'
task :setup_production_twitter_user_config do
  username = Capistrano::CLI.password_prompt 'Twitter Username:'
  password = Capistrano::CLI.password_prompt 'Twitter Password:'
  
  require 'yaml'
  config = { :username=>username, :password=>password }
  
  run "mkdir -p #{shared_path}/config"
  put config.to_yaml, "#{shared_path}/config/twitter_user.yaml"
end
after 'deploy:setup', :setup_production_twitter_user_config

desc 'Carries twitter_user.yml forward on update.'
task :copy_production_twitter_user_config do
  run "cp #{shared_path}/config/twitter_user.yaml #{release_path}/config/twitter_user.yaml"
end
after 'deploy:update_code', :copy_production_twitter_user_config
