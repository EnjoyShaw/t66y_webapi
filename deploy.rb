require 'mina/bundler'
require 'mina/git'
require 'mina/rvm'
require 'mina/unicorn'

set :domain, 'lolipop.moe'
set :deploy_to, '/var/www/t66y_webapi'
set :user, 'root'
set :port, '22'
set :forward_agent, false
set :repository, 'git@10.16.177.235:shaw/ssmis_mobile.git'
set :branch, 'master'
set :shared_paths, %w(log)
set :unicorn_pid, "#{deploy_to}/#{shared_path}/tmp/pids/unicorn.pid"
set :unicorn_env, 'production'
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]
  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]
  queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets"]
end
desc 'Deploys the current version to the server.'
task :deploy => :environment do
  to :before_hook do
  end
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'deploy:cleanup'
    to :launch do
      invoke :'unicorn:restart'
    end
  end
end