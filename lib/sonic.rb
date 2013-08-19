require "sonic/version"
require "rails"
module Sonic
  autoload :ServiceChecker,       'sonic/service_checker'

  class Engine < Rails::Engine
    isolate_namespace Sonic
  end
end
