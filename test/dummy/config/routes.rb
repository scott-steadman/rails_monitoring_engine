Rails.application.routes.draw do
  mount RailsMonitoringEngine::Engine => "/rails_monitoring_engine"
end
