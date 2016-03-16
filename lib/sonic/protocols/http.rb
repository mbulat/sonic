require 'net/http'

module Sonic
  module Protocol
    class HTTP
      include Protocol::Base

      def initialize(service_checker)
        @service_checker = service_checker
        @http = Net::HTTP.new(service_checker.host, service_checker.port)
        if service_checker.protocol == :https
          @http.use_ssl = true
          @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        @request = Net::HTTP::Get.new(service_checker.path)
      end

      def get
        begin
          response = @http.request(@request)
          @service_checker.response = response.body
          case response.code
          when '200', '201', '202', '203', '204', '205', '206'
            true
          else
            @service_checker.error = response.error
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
