module RailsMonitoringEngine::Concerns::Logging
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods

    LOGGING_DATA_KEY = :_rails_monitoring_engine_data

    def setup_logging
      raise NoMethodError.new('setup_logging must be implemented in descendant')
    end

    def start_logging(parms)
      setup_logging
      logging_data[:start_time] = Time.now
    end

    def finish_logging(params)
      parent_data                      = Thread.current[LOGGING_DATA_KEY]
      Thread.current[LOGGING_DATA_KEY] = {}

      Thread.new do
        add_logging_data(parent_data)
        write_log(params)

        Thread.exit
      end
    end

  private

    def logging_data(thread=Thread.current)
      thread[LOGGING_DATA_KEY] ||= {}
    end

    def add_logging_data(more_data)
      logging_data.merge!(more_data)
    end

    def write_log(params)
      end_time = Time.now
      logging_data.merge!(params) if params

      attrs = logging_data.merge(
        :host_name        => Socket.gethostname,
        :total_time       => 1_000 * (end_time - logging_data[:start_time]),
        :thread_count     => Thread.list.size
      )

      create!(attrs)

    rescue StandardError => ex
      Rails.logger.warn {"Unable to write log(#{attrs}): #{ex.message}"}
    end

  end # module ClassMethods

end # module RailsMonitoringEngine::Concerns::Logging
