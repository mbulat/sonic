require 'clockwork'
require 'sonic'
require 'json'

unless defined?(Sonic::SONIC_CHECKS)
  raise "Sonic checks not configured. Please ensure your sonic configration file is correct"
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
