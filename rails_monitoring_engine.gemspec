$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "rails_monitoring_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_monitoring_engine"
  s.version     = RailsMonitoringEngine::VERSION
  s.authors     = ["Scott Steadman"]
  s.email       = ["ss@stdmn.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of RailsMonitoringEngine."
  s.description = "TODO: Description of RailsMonitoringEngine."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.1"

  s.add_development_dependency "sqlite3"
end
