require_relative '../test_helper'

class RailsMonitoringEngine::RailsMonitoringEngineTest < ActiveSupport::TestCase

  def teardown
    RailsMonitoringEngine.disable!
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

  test 'monitor requires a block' do
    assert_raise ArgumentError do
      RailsMonitoringEngine.monitor({})
    end
  end

  test 'monitor when disabled' do
    RailsMonitoringEngine.disable!

    assert_difference 'RailsMonitoringEngine::ControllerActionLog.count', 0 do
      RailsMonitoringEngine.monitor({}) do
        simulate_controller_action_invocation
      end
    end
  end

  test 'monitor when enabled' do
    RailsMonitoringEngine.enable!

    assert_difference 'RailsMonitoringEngine::ControllerActionLog.count', 1 do
      RailsMonitoringEngine.monitor({}) do
        simulate_controller_action_invocation
      end
      wait_for_threads
    end
  end

  test 'monitor with noop block' do
    RailsMonitoringEngine.enable!
    block_executed = false

    assert_difference 'RailsMonitoringEngine::ControllerActionLog.count', 0 do
      RailsMonitoringEngine.monitor({}) do
        block_executed = true
      end
      wait_for_threads
    end

    assert block_executed, 'block should be executed'
  end

private

  def simulate_controller_action_invocation
    attrs = {
      :controller   => 'controller',
      :action       => 'action',
      :view_runtime => 42,
      :db_runtime   => 42,
    }
    ActiveSupport::Notifications.instrument('process_action.action_controller', attrs) do
      # nothing
    end
  end

end # class RailsMonitoringEngineTest
