require_relative '../../../test_helper'

class RailsMonitoringEngine::LoggingTest < ActiveSupport::TestCase

  class Dummy
    include RailsMonitoringEngine::Concerns::Logging
  end

  test 'setup_logging must be implemented' do
    assert_raise NoMethodError do
      Dummy.setup_logging
    end
  end

end # class RailsMonitoringEngine::LoggingTest
