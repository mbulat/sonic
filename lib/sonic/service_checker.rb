module Sonic
  class ServiceChecker

    attr_reader :protocol
    attr_reader :host
    attr_reader :port

    def initialize(protocol, host, port)
      @protocol = protocol
      @host     = host
      @port     = port
    end

  end
end
