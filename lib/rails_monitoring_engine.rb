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

  def self.start!
    data[:start_time] = Time.now
  end

  def self.finish!(env)
    data[:end_time] = Time.now

  end

  def self.data
    Thread.current[:_rails_monitoring_engine_data] ||= {}
  end

end
