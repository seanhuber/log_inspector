module LogInspector
  class Engine < ::Rails::Engine
    isolate_namespace LogInspector

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.assets false
      g.helper false
    end

    engine_name 'log_inspector'
  end
end
