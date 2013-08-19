require "sonic/version"
require "rails"
module Sonic
  class Engine < Rails::Engine
    isolate_namespace Sonic
  end
end
