# == Schema Information
#
# Table name: rails_monitoring_engine_controller_action_logs
#
#  action_name     :string           not null
#  controller_name :string           not null
#  database_time   :float
#  extra_data      :text
#  host_name       :string           not null
#  queue_time      :float
#  render_time     :float
#  total_time      :float
#  created_at      :datetime         not null
#
# Indexes
#
#  controller_action_logs_on_controller_name_and_action_name  (controller_name,action_name)
#  controller_action_logs_on_created_at_and_host_name         (created_at,host_name)
#

module RailsMonitoringEngine
  class ControllerActionLog < ApplicationRecord
    include Concerns::Logging

    validates :host_name,       :presence => true
    validates :controller_name, :presence => true
    validates :action_name,     :presence => true

    serialize :extra_data

    def initialize(attrs)
      super(extract_attrs_and_extra_data(attrs))
    end

    def self.setup_logging
      return if @subscribed
      @subscribed = true

      ActiveSupport::Notifications.subscribe("process_action.action_controller") do |*args|
        params = args.extract_options!

        add_logging_data(
          :controller_name => params[:controller],
          :action_name     => params[:action],
          :render_time     => params[:view_runtime],
          :database_time   => params[:db_runtime]
        )
      end
    end

  private

    def extract_attrs_and_extra_data(attrs)
      attrs, extra_data = attrs.partition {|key, value| self.class.column_names.include?(key.to_s)}.map(&:to_h)
      attrs.merge(:extra_data => extra_data)
    end

  end # class ControllerActionLog
end # module RailsMonitoringEngine
