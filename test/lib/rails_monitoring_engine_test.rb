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

end # class RailsMonitoringEngineTest
