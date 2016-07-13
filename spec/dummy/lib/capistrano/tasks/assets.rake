namespace :assets do
  task :precompile do
    on release_roles(fetch(:assets_roles)) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          puts "\n\n\n--------------------------------------#{release_path}\n\n\n"
          execute :rake, "assets:precompile"
        end
      end
    end
  end
end
