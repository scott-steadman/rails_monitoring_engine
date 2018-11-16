class CreateRailsMonitoringEngineControllerActionLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :rails_monitoring_engine_controller_action_logs, :id => false do |t|
      t.datetime  :created_at,      :null => false

      t.string    :host_name,       :null => false
      t.string    :controller_name, :null => false
      t.string    :action_name,     :null => false

      t.float     :queue_time
      t.float     :database_time
      t.float     :render_time
      t.float     :total_time

      t.text      :extra_data

      t.index [:created_at, :host_name], :name => 'controller_action_logs_on_created_at_and_host_name'
      t.index [:controller_name, :action_name], :name => 'controller_action_logs_on_controller_name_and_action_name'
    end
  end
end
