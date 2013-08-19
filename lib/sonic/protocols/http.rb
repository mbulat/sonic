require 'net/http'

module Sonic
  module Protocol
    class HTTP
      include Protocol::Base

      def initialize(service_checker)
        @service_checker = service_checker
        port_suffix = service_checker.port ? ":#{service_checker.port}" : ""
        @uri = URI.parse("#{service_checker.protocol}://#{service_checker.host}#{port_suffix}/#{service_checker.path}")
      end

      def get
        begin
          @service_checker.response = Net::HTTP.get_response(@uri)
          case @service_checker.response.code
          when '200', '201', '202', '203', '204', '205', '206'
            true
          else
            @service_checker.error = "service error"
            false
          end
        rescue SocketError
          @service_checker.error = "service unavailable"
          false
        end
      end

    end
  end
end
