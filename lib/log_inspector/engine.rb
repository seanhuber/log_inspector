module LogInspector
  class Engine < ::Rails::Engine
    isolate_namespace LogInspector

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.assets false
      g.helper false
    end

    engine_name 'log_inspector'

    initializer 'log_inspector.assets.precompile' do |app|
      app.config.assets.precompile += ['folder-tree.js', 'log_inspector.js', 'folder-tree.css', 'log-inspector.css']
    end
  end
end
