namespace :deploy do
  namespace :assets do
    Rake::Task["deploy:assets:precompile"].clear_actions
    task :precompile do
      on release_roles(fetch(:assets_roles)) do
        within File.join(release_path, 'spec', 'dummy') do
          with rails_env: fetch(:rails_env) do
            # info "\n\n\n--------------------------------------#{release_path}\n\n\n"
            execute :rake, "assets:precompile"
          end
        end
      end
    end

    Rake::Task["deploy:assets:backup_manifest"].clear_actions
    task :backup_manifest do
      on release_roles(fetch(:assets_roles)) do
        within File.join(release_path, 'spec', 'dummy') do
          backup_path = release_path.join('assets_manifest_backup')

          execute :mkdir, '-p', backup_path
          execute :cp,
            detect_manifest_path,
            backup_path
        end
      end
    end
  end
end
