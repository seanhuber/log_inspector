$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "log_inspector/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "log_inspector"
  s.version     = LogInspector::VERSION
  s.authors     = ["Sean Huber"]
  s.email       = ["seanhuber@seanhuber.com"]
  s.homepage    = "http://asdf.com"
  s.summary     = "asdf`: Summary of LogInspector."
  s.description = "asdf: Description of LogInspector."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.6"

  s.add_development_dependency "sqlite3"
end
