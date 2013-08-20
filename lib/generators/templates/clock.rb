require 'clockwork'
require 'sonic'
require 'json'

begin
  require File.expand_path('../../config/initializers/sonic_config.rb', __FILE__)
rescue LoadError
  puts "\e[31mSonic checks not configured. Run 'rails g sonic' and configure checks.\e[0m"
  exit
end

module Clockwork

  handler do |job|
    case job
    when 'run.checks' 
      results = {}
      Sonic::SONIC_CHECKS.each do |service_checker|
        service_checker.check_service
        results[service_checker.protocol] = {}
        results[service_checker.protocol][:timestamp] = DateTime.now
        results[service_checker.protocol][:response] = service_checker.response
        results[service_checker.protocol][:error] = service_checker.error
      end

      json = results.to_json
      path = FileUtils.mkdir_p "public/sonic"
      File.open("#{path[0]}/results.json", 'w') {|f| f.write(json) }
      puts "Completed checks"
      
    end
  end

  every(3.minutes, 'run.checks', :thread => true)

end
