module Sonic
  class ServiceChecker

    attr_accessor :protocol
    attr_accessor :host
    attr_accessor :port
    attr_accessor :path
    attr_accessor :payload
    attr_accessor :ssl_key
    attr_accessor :ssl_cert
    attr_accessor :response
    attr_accessor :error

    def initialize(protocol, host, port, path=nil, payload=nil, ssl_cert=nil, ssl_key=nil)
      @protocol = protocol
      @host     = host
      @port     = port
      @path     = path
      @payload  = payload
      @ssl_key  = ssl_key
      @ssl_cert  = ssl_cert
    end

    def check_service()
      case protocol
      when :http, :https
        http = Protocol::HTTP.new(self)
        http.get
      when :tcp
        tcp = Protocol::TCP.new(self)
        tcp.send
      end
    end

  end
end
