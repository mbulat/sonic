require "sonic/version"
require "rails"
module Sonic
  autoload :ServiceChecker,       'sonic/service_checker'
  module Protocol
    autoload :Base,       'sonic/protocols/base'
    autoload :HTTP,       'sonic/protocols/http'
    autoload :AMQP,       'sonic/protocols/amqp'
    autoload :TCP,        'sonic/protocols/tcp'
  end

  class Engine < Rails::Engine
    isolate_namespace Sonic
  end
end
