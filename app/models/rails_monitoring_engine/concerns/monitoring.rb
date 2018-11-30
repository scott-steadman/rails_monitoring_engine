module RailsMonitoringEngine::Concerns::Monitoring
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods

    MONITORING_DATA_KEY = :_rails_monitoring_engine_data

    def setup_monitoring
      raise NoMethodError.new('setup_monitoring must be implemented in descendant')
    end

    def start_monitoring(parms)
      setup_monitoring
      monitoring_data[:start_time] = Time.now
    end

    def finish_monitoring(params)
      parent_data                         = Thread.current[MONITORING_DATA_KEY]
      Thread.current[MONITORING_DATA_KEY] = {}

      Thread.new do
        add_monitoring_data(parent_data)
        write_log(params)

        Thread.exit
      end
    end

  private

    def monitoring_data(thread=Thread.current)
      thread[MONITORING_DATA_KEY] ||= {}
    end

    def add_monitoring_data(more_data)
      monitoring_data.merge!(more_data)
    end

    def write_log(params)
      end_time = Time.now
      monitoring_data.merge!(params) if params

      attrs = monitoring_data.merge(
        :host_name        => Socket.gethostname,
        :total_time       => 1_000 * (end_time - monitoring_data[:start_time]),
        :thread_count     => Thread.list.size
      )

      create!(attrs)

    rescue StandardError => ex
      Rails.logger.warn {"Unable to write log(#{attrs}): #{ex.message}"}
    end

  end # module ClassMethods

end # module RailsMonitoringEngine::Concerns::Monitoring
