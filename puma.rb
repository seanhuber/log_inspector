#!/usr/bin/env puma

directory '/var/www/log_inspector/current/spec/dummy'
rackup "/var/www/log_inspector/current/spec/dummy/config.ru"
environment 'production'

pidfile "/var/www/log_inspector/shared/tmp/pids/puma.pid"
state_path "/var/www/log_inspector/shared/tmp/pids/puma.state"
stdout_redirect '/var/www/log_inspector/shared/log/puma_access.log', '/var/www/log_inspector/shared/log/puma_error.log', true


threads 0,16

bind 'unix:///var/www/log_inspector/shared/tmp/sockets/puma.sock'

workers 0



prune_bundler


on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = "/var/www/log_inspector/current/Gemfile"
end
