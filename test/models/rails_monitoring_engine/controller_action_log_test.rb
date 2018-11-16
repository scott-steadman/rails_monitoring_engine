require 'test_helper'

module RailsMonitoringEngine
  class ControllerActionLogTest < ActiveSupport::TestCase

    test 'initialize saves extra attrs in extra_data' do
      model = ControllerActionLog.new(:controller_name => 'foo', :bar => 'baz')

      assert_equal 'foo', model.controller_name,   'controller_name should be set'
      assert_equal 'baz', model.extra_data[:bar],  'extra_data should be set'
    end
  end
end
