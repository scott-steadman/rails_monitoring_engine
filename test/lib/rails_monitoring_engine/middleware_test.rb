require_relative '../../test_helper'

class RailsMonitoringEngine::MiddlewareTest < ActiveSupport::TestCase

  class DummyApp
    def call(env)
      return [200, {'X-Header-Key' => 'header value'}, ['content']]
    end
  end

  test 'call' do
    env = {}
    app = DummyApp.new
    app.expects(:call).with(env).once

    middleware = RailsMonitoringEngine::Middleware.new(app) do |params|
      assert params.has_key?(:env),         ':env parameter missing'
      assert params.has_key?(:start_time), ':start_time parameter missing'
      assert params.has_key?(:end_time),   ':end_time parameter missing'
    end

    middleware.call(env)
  end

end # class MiddlewareTest
