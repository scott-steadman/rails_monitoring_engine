require_relative '../../test_helper'

class RailsMonitoringEngine::MiddlewareTest < ActiveSupport::TestCase

  RESULT = [200, {'X-Header-Key' => 'header value'}, ['content']]

  class DummyApp
    def call(env)
      return RESULT
    end
  end

  test 'call' do
    env        = {}
    app        = DummyApp.new
    middleware = RailsMonitoringEngine::Middleware.new(app)

    RailsMonitoringEngine.enable!
    assert_equal RESULT, middleware.call(env)
    wait_for_threads
  end

end # class MiddlewareTest
