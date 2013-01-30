# Number of workers (Rule of thumb is 2 per CPU)
# Just be aware that every worker needs to cache all classes and thus eat some
# of your RAM.
set_default :unicorn_workers, 2

# Workers timeout in the amount of seconds below, when the master kills it and
# forks another one.
set_default  :unicorn_workers_timeout, 30

# Workers are started with this user
# By default we get the user/group set in capistrano.
set_default  :unicorn_user, user

# The wrapped bin to start unicorn
set_default  :unicorn_bin, 'bin/unicorn'
set_default  :unicorn_socket, fetch(:app_server_socket)

# Defines where the unicorn pid will live.
set_default  :unicorn_pid, File.join(current_path, "tmp", "pids", "unicorn.pid")

# Preload app for fast worker spawn
set_default :unicorn_preload, true

# Unicorn
#------------------------------------------------------------------------------
namespace :unicorn do
  desc "Starts unicorn directly"
  task :start, :roles => :app do
    run "cd #{current_path} && #{unicorn_bin} -c #{shared_path}/config/unicorn.rb -E #{rails_env} -D"
  end

  desc "Stops unicorn directly"
  task :stop, :roles => :app do
    run "kill -QUIT `cat #{unicorn_pid}`"
  end

  desc "Restarts unicorn directly"
  task :restart, :roles => :app do
    run "kill -USR2 `cat #{unicorn_pid}`"
  end

  after "deploy:setup", "unicorn:setup"
  desc "Setup unicorn configuration for this application."
   task :setup, roles: :app do
    template "unicorn.erb", "/tmp/unicorn.rb"
    run "#{sudo} mv /tmp/unicorn.rb #{shared_path}/config/"
  end

  after "deploy", "unicorn:restart"
  after "deploy:cold", "unicorn:start"
end


# after 'deploy:setup' do
#   unicorn.setup if Capistrano::CLI.ui.agree("Create unicorn configuration file? [Yn]")
# end if is_using_unicorn