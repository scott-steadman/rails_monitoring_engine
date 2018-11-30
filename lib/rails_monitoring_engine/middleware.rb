class RailsMonitoringEngine::Middleware

  def initialize(app)
    @app = app
  end

  def call(env)
    params              = {}
    params[:queue_time] = Time.parse(env['X-Request-Start']) if env.has_key?('X-Request-Start')

    RailsMonitoringEngine.monitor(params) do
      @app.call(env)
    end
  end

end # class RailsMonitoringEngine::Middleware
