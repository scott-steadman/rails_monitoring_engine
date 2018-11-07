require_relative '../../test_helper'

class RailsMonitoringEngine::ConfigurationTest < ActiveSupport::TestCase

  def teardown
    RailsMonitoringEngine.disable!
  end

  test 'enable!' do
    configuration.enable!
    assert RailsMonitoringEngine.enabled?
  end

  test 'disable!' do
    configuration.enable!
    configuration.disable!
    assert !RailsMonitoringEngine.enabled?
  end

private

  def configuration
    @configuration ||= RailsMonitoringEngine::Configuration.new
  end

end # class ConfigurationTest
