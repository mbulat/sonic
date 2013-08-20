require 'bunny'

module Sonic
  module Protocol
    class AMQP
      include Protocol::Base

      def initialize(service_checker)
        @service_checker = service_checker  
      end

      def check
        begin
          conn = Bunny.new(:host => @service_checker.host, :port => @service_checker.port)
          @service_checker.response = conn.start
          if @service_checker.response == :connected
            true
          else
            @service_checker.error = "service error"
            false
          end
        rescue Exception => e
          @service_checker.error = e.to_s
          false
        end
      end

    end
  end
end
