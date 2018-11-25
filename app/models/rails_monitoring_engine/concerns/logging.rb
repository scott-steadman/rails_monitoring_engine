module RailsMonitoringEngine::Concerns::Logging
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods

    def setup
      return if @subscribed
      @subscribed = true

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

    def start_logging
      data[:start_time] = Time.now
    end

    def finish_logging(env)
      parent = Thread.current
      Thread.new do
        data.merge!(data(parent))
        write_log(env)

        Thread.exit
      end
    end

  private

    def data(thread=Thread.current)
      thread[:_rails_monitoring_engine_data] ||= {}
    end

    def write_log(env)
      end_time          = Time.now
      data[:queue_time] = Time.parse(env['X-Request-Start']) if env.has_key?('X-Request-Start')

      attrs = data.merge(
        :host_name        => Socket.gethostname,
        :total_time       => 1_000 * (end_time - data[:start_time]),
        :thread_count     => Thread.list.size
      )

      create!(attrs)

    rescue StandardError => ex
      Rails.logger.warn {"Unable to write log(#{attrs}): #{ex.message}"}
    end

  end # module ClassMethods

end # module RailsMonitoringEngine::Concerns::Logging
