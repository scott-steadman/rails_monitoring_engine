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

    ActiveSupport::Notifications.subscribe("process_action.action_controller") do |*args|
      params = args.extract_options!

      data.merge!(
        :controller_name => params[:controller],
        :action_name     => params[:action],
        :render_time     => params[:view_runtime],
        :database_time   => params[:db_runtime]
      )
    end
  end

  def self.start!
    return unless enabled?

    data[:start_time] = Time.now
  end

  def self.finish!(env)
    return unless enabled?

    parent = Thread.current
    Thread.new do
      data.merge!(data(parent))
      log_controller_action(env)

      Thread.exit
    end
  end

  def self.data(thread=Thread.current)
    thread[:_rails_monitoring_engine_data] ||= {}
  end

private

  def self.log_controller_action(env)
    end_time          = Time.now
    data[:queue_time] = Time.parse(env['X-Request-Start']) if env.has_key?('X-Request-Start')

    attrs = data.merge(
      :host_name        => Socket.gethostname,
      :total_time       => 1_000 * (end_time - data[:start_time]),
      :thread_count     => ThreadGroup::Default.list.size
    )

    ControllerActionLog.create!(attrs)

  rescue StandardError => ex
    Rails.logger.warn {"Unable to create ControllerActionLog(#{attrs}): #{ex.message}"}
  end

end
