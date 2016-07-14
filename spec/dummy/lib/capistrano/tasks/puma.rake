namespace :load do
  Rake::Task["load:defaults"].clear_actions
  task :defaults do
    set :puma_default_hooks, -> { true }
    set :puma_role, :app
    set :puma_env, -> { fetch(:rack_env, fetch(:rails_env, fetch(:stage))) }
    # Configure "min" to be the minimum number of threads to use to answer
    # requests and "max" the maximum.
    set :puma_threads, [0, 16]
    set :puma_workers, 0
    set :puma_rackup, -> { File.join(current_path, 'spec', 'dummy', 'config.ru') }
    set :puma_state, -> { File.join(shared_path, 'tmp', 'pids', 'puma.state') }
    set :puma_pid, -> { File.join(shared_path, 'tmp', 'pids', 'puma.pid') }
    set :puma_bind, -> { File.join("unix://#{shared_path}", 'tmp', 'sockets', 'puma.sock') }
    set :puma_default_control_app, -> { File.join("unix://#{shared_path}", 'tmp', 'sockets', 'pumactl.sock') }
    set :puma_conf, -> { File.join(shared_path, 'puma.rb') }
    set :puma_access_log, -> { File.join(shared_path, 'log', 'puma_access.log') }
    set :puma_error_log, -> { File.join(shared_path, 'log', 'puma_error.log') }
    set :puma_init_active_record, false
    set :puma_preload_app, false

    # Chruby, Rbenv and RVM integration
    append :chruby_map_bins, 'puma', 'pumactl'
    append :rbenv_map_bins, 'puma', 'pumactl'
    append :rvm_map_bins, 'puma', 'pumactl'

    # Bundler integration
    append :bundle_bins, 'puma', 'pumactl'
  end
end

namespace :puma do
  desc 'Start puma'
  Rake::Task["puma:start"].clear_actions
  task :start do
    on roles (fetch(:puma_role)) do |role|
      puma_switch_user(role) do
        if test "[ -f #{fetch(:puma_conf)} ]"
          info "using conf file #{fetch(:puma_conf)}"
        else
          invoke 'puma:config'
        end
        within File.join(current_path, 'spec', 'dummy') do
          with rack_env: fetch(:puma_env) do
            execute :puma, "-C #{fetch(:puma_conf)} --daemon"
          end
        end
      end
    end
  end

  %w[halt stop status].map do |command|
    desc "#{command} puma"
    Rake::Task["puma:#{command}"].clear_actions
    task command do
      on roles (fetch(:puma_role)) do |role|
        within File.join(current_path, 'spec', 'dummy') do
          puma_switch_user(role) do
            with rack_env: fetch(:puma_env) do
              if test "[ -f #{fetch(:puma_pid)} ]"
                if test :kill, "-0 $( cat #{fetch(:puma_pid)} )"
                  execute :pumactl, "-S #{fetch(:puma_state)} -F #{fetch(:puma_conf)} #{command}"
                else
                  # delete invalid pid file , process is not running.
                  execute :rm, fetch(:puma_pid)
                end
              else
                #pid file not found, so puma is probably not running or it using another pidfile
                warn 'Puma not running'
              end
            end
          end
        end
      end
    end
  end

  %w[phased-restart restart].map do |command|
    desc "#{command} puma"
    Rake::Task["puma:#{command}"].clear_actions
    task command do
      on roles (fetch(:puma_role)) do |role|
        within File.join(current_path, 'spec', 'dummy') do
          puma_switch_user(role) do
            with rack_env: fetch(:puma_env) do
              if test "[ -f #{fetch(:puma_pid)} ]" and test :kill, "-0 $( cat #{fetch(:puma_pid)} )"
                # NOTE pid exist but state file is nonsense, so ignore that case
                execute :pumactl, "-S #{fetch(:puma_state)} -F #{fetch(:puma_conf)} #{command}"
              else
                # Puma is not running or state file is not present : Run it
                invoke 'puma:start'
              end
            end
          end
        end
      end
    end
  end
end
