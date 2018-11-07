class RailsMonitoringEngine::Middleware

  def initialize(app)
    @app = app
  end

  def call(env)
    RailsMonitoringEngine.start! if RailsMonitoringEngine.enabled?

    return @app.call(env)

  ensure
    if RailsMonitoringEngine.enabled?
      Thread.new do
        RailsMonitoringEngine.finish!(env)
        Thread.exit
      end
    end
  end

end # class RailsMonitoringEngine::Middleware
