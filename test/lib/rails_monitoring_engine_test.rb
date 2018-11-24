require_relative '../test_helper'

class RailsMonitoringEngine::RailsMonitoringEngineTest < ActiveSupport::TestCase

  def teardown
    RailsMonitoringEngine.disable!
  end

  test 'disabled by default' do
    assert !RailsMonitoringEngine.enabled?, 'RailsMonitoringEngine should be disabled by default'
  end

  test 'enable/disable' do
    RailsMonitoringEngine.enable!
    assert RailsMonitoringEngine.enabled?, 'enable! failed'

    RailsMonitoringEngine.disable!
    assert !RailsMonitoringEngine.enabled?, 'disable! failed'
  end

  test 'configure requires a block' do
    assert_raise ArgumentError do
      RailsMonitoringEngine.configure
    end
  end

  test 'configure' do
    RailsMonitoringEngine.configure do
      enable!
    end

    assert RailsMonitoringEngine.enabled?, 'configure failed'
  end

  test 'logging' do
    RailsMonitoringEngine.configure do
      enable!
    end

    RailsMonitoringEngine.start!

    attrs = {
      :controller   => 'controller',
      :action       => 'action',
      :view_runtime => 42,
      :db_runtime   => 42,
    }
    ActiveSupport::Notifications.instrument('process_action.action_controller', attrs) do
      # nothing
    end

    assert_difference 'RailsMonitoringEngine::ControllerActionLog.count', 1 do
      RailsMonitoringEngine.finish!({})
      sleep(1)
    end
  end

  test 'logging handles errors' do
    RailsMonitoringEngine.configure do
      enable!
    end

    RailsMonitoringEngine.start!

    ActiveSupport::Notifications.instrument('process_action.action_controller', {}) do
      # nothing
    end

    assert_difference 'RailsMonitoringEngine::ControllerActionLog.count', 0 do
      RailsMonitoringEngine.finish!({})
    end
  end


end # class RailsMonitoringEngineTest
