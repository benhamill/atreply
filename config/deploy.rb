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