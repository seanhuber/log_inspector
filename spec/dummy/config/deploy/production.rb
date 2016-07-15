server 'seanhuber.com', roles: [:web, :app], ssh_options: { user: 'sean', forward_agent: false }

set :puma_bind, "0.0.0.0:8080"
