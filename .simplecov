SimpleCov.start 'rails' do
  add_filter   '/bundle/'
  add_filter   'lib/tasks'
  add_filter   'lib/rails_monitoring_engine/version.rb'
  coverage_dir 'test/dummy/public/coverage'
end
