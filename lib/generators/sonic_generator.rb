require 'rails/generators'

class SonicGenerator < Rails::Generators::Base
  def self.source_root
    @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end

  def copy_clock_file
   copy_file 'clock.rb', 'lib/sonic_clock.rb'
  end

  def copy_config_template
   copy_file 'config.rb', 'config/initializers/sonic_config.rb'
  end

  def show_readme
    readme "README" if behavior == :invoke
  end
end
