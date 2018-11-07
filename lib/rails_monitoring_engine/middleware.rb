class RailsMonitoringEngine::Middleware

  def initialize(app, &blk)
    raise ArgumentError.new('A block is required') unless block_given?

    @app = app
    @blk = blk
  end

  def call(env)
    start_time  = Time.now
    return @app.call(env)
  ensure
    @blk.call(:env => env, :start_time => start_time, :end_time => Time.now)
  end

end # class RailsMonitoringEngine::Middleware
