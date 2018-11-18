class RailsMonitoringEngine::Middleware

  def initialize(app)
    @app = app
  end

  def call(env)
    RailsMonitoringEngine.start! if RailsMonitoringEngine.enabled?

    return @app.call(env)

  ensure
    RailsMonitoringEngine.finish!(env) if RailsMonitoringEngine.enabled?
  end

end # class RailsMonitoringEngine::Middleware
