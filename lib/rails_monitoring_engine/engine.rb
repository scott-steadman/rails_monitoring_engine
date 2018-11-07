require_relative 'middleware'

module RailsMonitoringEngine
  class Engine < ::Rails::Engine
    isolate_namespace RailsMonitoringEngine

    initializer "rails_monitoring_engine.middleware" do |app|
      app.config.app_middleware.use RailsMonitoringEngine::Middleware
    end
  end # class Engine
end # module RailsMonitoringEngine
