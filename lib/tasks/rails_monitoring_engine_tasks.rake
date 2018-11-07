# desc "Explaining what the task does"
# task :rails_monitoring_engine do
#   # Task goes here
# end

  desc 'run coverage'
  task :coverage do
    require 'simplecov'
    FileUtils.rm_rf(Rails.root + 'test/dummy/public/coverage')
    SimpleCov.start 'rails' do
      add_filter '/bundle/'
      add_filter 'lib/rails_monitoring_engine/version.rb'
      coverage_dir 'test/dummy/public/coverage'
    end

    Rake::Task[:test].invoke
  end
