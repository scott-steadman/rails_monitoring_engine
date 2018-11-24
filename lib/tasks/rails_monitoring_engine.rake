require 'mkmf'

namespace :test do

  desc 'Hammer localhost with requests'
  task :performance do
    begin
      options = []
      options << '-k'       # KeepAlive - use single connection
      options << '-n 100'   # perform 100 requests

      command = "ab #{options.join(' ')} http://localhost:3000/ "
      puts "Executing: #{command}"

      system "#{command}"
    rescue StandardError => ex
      puts "#{ex.message}\n\nIs the Apache Benchmarking Tool installed?"
    end
  end

end # namespace test
