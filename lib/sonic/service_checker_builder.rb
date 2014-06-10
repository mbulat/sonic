module Sonic
  class ServiceCheckerBuilder
    def protocol(v=nil); @protocol = v; self; end
    def host(v=nil); @host = v; self; end
    def username(v=nil); @username = v; self; end
    def password(v=nil); @password = v; self; end
    def vhost(v=nil); @vhost = v; self; end
    def port(v=nil); @port = v; self; end
    def path(v=nil); @path = v; self; end
    def payload(v=nil); @payload = v; self; end
    def ssl_cert(v=nil); @ssl_cert = v; self; end
    def ssl_key(v=nil); @ssl_key = v; self; end
    def build
      Sonic::ServiceChecker.new(@protocol, @host, @port, @username, @password, @vhost, @path, @payload, @ssl_cert, @ssl_key)
    end
  end
end
