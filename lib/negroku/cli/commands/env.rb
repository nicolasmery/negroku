module Negroku::CLI

  desc 'Manage your apps env variables'
  command :env do |app|

    app.desc 'Adds multiple variables from rbenv-vars to a server'
    app.command :bulk do |bulk|
      bulk.action do |global_options,options,args|
        Negroku::Env.bulk
      end
    end

  end
end
