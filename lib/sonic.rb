require "docile"
require "sonic/version"
require "rails"

module Sonic
  autoload :ServiceChecker,         'sonic/service_checker'
  autoload :ServiceCheckerBuilder,  'sonic/service_checker_builder'
  module Protocol
    autoload :Base,       'sonic/protocols/base'
    autoload :HTTP,       'sonic/protocols/http'
    autoload :AMQP,       'sonic/protocols/amqp'
    autoload :TCP,        'sonic/protocols/tcp'
  end

  class Engine < Rails::Engine
    isolate_namespace Sonic
  end

  def self.service_checker(&block)
    Docile.dsl_eval(Sonic::ServiceCheckerBuilder.new, &block).build
  end
end
