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
    called     = false
    middleware = RailsMonitoringEngine::Middleware.new(app) do |params|
      called = true
      assert params.has_key?(:env),        ':env parameter missing'
      assert params.has_key?(:start_time), ':start_time parameter missing'
      assert params.has_key?(:end_time),   ':end_time parameter missing'
    end
    app.expects(:call).with(env).once

    RailsMonitoringEngine.enable!
    middleware.call(env)

    assert called, 'block should be called'
  end

  test 'block not called when disabled' do
    env        = {}
    app        = DummyApp.new
    called     = false
    middleware = RailsMonitoringEngine::Middleware.new(app) do |params|
      called = true
    end
    app.expects(:call).with(env).once

    RailsMonitoringEngine.disable!
    middleware.call(env)

    assert !called, 'block should NOT be called'
  end

end # class MiddlewareTest
