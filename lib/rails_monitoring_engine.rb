require "rails_monitoring_engine/engine"
require "rails_monitoring_engine/configuration"

module RailsMonitoringEngine

  def self.enable!
    @enabled = true
  end

  def self.disable!
    @enabled = false
  end

  def self.enabled?
    !!@enabled
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure(&block)
    raise ArgumentError.new('A block is required') unless block_given?

    configuration.instance_exec(&block)
  end

  def self.monitor(params)
    raise ArgumentError.new('A block is required') unless block_given?

    ControllerActionLog.start_logging(params) if enabled?
    return yield
  ensure
    ControllerActionLog.finish_logging(params) if enabled?
  end

end # module RailsMonitoringEngine
