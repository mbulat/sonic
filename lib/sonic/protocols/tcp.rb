require 'socket'

module Sonic
  module Protocol
    class TCP
      include Protocol::Base

      def initialize(service_checker)
        @service_checker = service_checker
        @host = service_checker.host
        @port = service_checker.port
        @payload = service_checker.payload
        @ssl_key = service_checker.ssl_key
        @ssl_cert = service_checker.ssl_cert
      end

      def send
        begin
          connection = TCPSocket.new(@host, @port)
          if @ssl_cert && @ssl_key
            ssl_context = OpenSSL::SSL::SSLContext.new()
            ssl_context.cert = OpenSSL::X509::Certificate.new(File.read("#{Dir.pwd}/ssl/#{@ssl_cert}"))
            ssl_context.ca_file = "#{Dir.pwd}/ssl/#{@ssl_cert}"
            ssl_context.key = OpenSSL::PKey::RSA.new(File.read("#{Dir.pwd}/ssl/#{@ssl_key}"))
            socket = OpenSSL::SSL::SSLSocket.new(connection, ssl_context)
            socket.sync_close = true
            socket.connect
          else
            socket = connection
          end
          socket.syswrite(@payload)
          read_tcp_response(socket)
          socket.close
          socket = nil
          if @service_checker.response
            true
          else
            false
          end
        rescue Exception => e
          @service_checker.error = e.to_s
          false
        end

      end

      private
        def read_tcp_response(socket)
          @service_checker.response = ""
          @service_checker.response << socket.sysread(1)
          while (@service_checker.response =~ /^.+?\n/) == nil
            @service_checker.response << socket.sysread(1)
          end
        end

    end
  end
end
