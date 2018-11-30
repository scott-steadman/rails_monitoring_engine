require_relative '../../../test_helper'

class RailsMonitoringEngine::MonitoringTest < ActiveSupport::TestCase

  class Dummy
    include RailsMonitoringEngine::Concerns::Monitoring
  end

  test 'setup_monitoring must be implemented' do
    assert_raise NoMethodError do
      Dummy.setup_monitoring
    end
  end

end # class RailsMonitoringEngine::MonitoringTest
