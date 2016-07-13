$:.push File.expand_path('../lib', __FILE__)
require 'log_inspector/version'

Gem::Specification.new do |s|
  s.name       = 'log_inspector'
  s.version    = LogInspector::VERSION
  s.authors    = ['Sean Huber']
  s.email      = ['seanhuber@seanhuber.com']
  s.homepage   = 'https://github.com/seanhuber/log_inspector'
  s.summary    = 'Rails Engine with routes for displaying logfile contents.'
  s.license    = 'MIT'
  s.files      = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '~> 4.0'
  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-webkit'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'pry-byebug'
end
