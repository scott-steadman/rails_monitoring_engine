require_relative '../../test_helper'

class RailsMonitoringEngine::MiddlewareTest < ActiveSupport::TestCase

  class DummyApp
    def call(env)
      return [200, {'X-Header-Key' => 'header value'}, ['content']]
    end
  end

  test 'call' do
    env        = {}
    app        = DummyApp.new
    middleware = RailsMonitoringEngine::Middleware.new(app)
    app.expects(:call).with(env).once
    RailsMonitoringEngine.expects(:finish!).with(env).once

    RailsMonitoringEngine.enable!
    middleware.call(env)
    wait_for_threads
  end

  test 'block not called when disabled' do
    env        = {}
    app        = DummyApp.new
    called     = false
    middleware = RailsMonitoringEngine::Middleware.new(app)
    app.expects(:call).with(env).once
    RailsMonitoringEngine.expects(:finish!).never

    RailsMonitoringEngine.disable!
    middleware.call(env)
    wait_for_threads
  end

end # class MiddlewareTest
