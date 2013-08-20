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
          conn = ::Bunny.new(:host => @service_checker.host, :port => @service_checker.port)
          conn.start
          @service_checker.response = conn.status
          if @service_checker.response == :open
            true
          else
            @service_checker.error = "service error"
            false
          end
          conn.close
        rescue Exception => e
          @service_checker.error = e.to_s
          false
        end
      end

    end
  end
end
