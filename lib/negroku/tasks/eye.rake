## eye.rb
#
# Adds eye variables and tasks
# Eye main tasks are taken from the gem capistrano-eye

# Here we are setting up the main negroku default to work with eye
namespace :load do
  task :defaults do
    # Add eye to :rbenv_map_bins
    fetch(:rbenv_map_bins) << 'eye'

    ###################################
    ## capistrano/eye variables



    ###################################
    ## application.eye template variables

    # Local path to look for custom config template
    set :eye_template, -> { "config/deploy/#{fetch(:stage)}/#{fetch(:application)}.eye.erb" }

    ###################################
    ## capistrano/eye variables

    # Add bower to :nodenv_map_bins
    set :app_server_socket, -> { fetch(:unicorn_socket) } if was_required? 'capistrano/nginx'

    # Prevents unicorn manage itself when to restart
    set :unicorn_manage_restart, false if was_required? 'capistrano3/unicorn'

  end
end

# Adds some task on complement the capistrano-eye tasks
# This tasks are under the negroku namespace for easier identification
namespace :negroku do

  namespace :eye do
    # Reload or restart the application after the application is published
    after 'deploy:publishing', 'restart' do
      invoke 'eye:restart'
    end

    # Ensure the folders needed exist
    after 'deploy:check', 'deploy:check:directories' do
      on release_roles fetch(:eye_roles) do
        execute :mkdir, '-pv', "#{shared_path}/config"
      end
    end

  end

end
