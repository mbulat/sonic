# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec, :cli => "-c --tty --format Fuubar", :all_on_start => true, :focus_on_failed => true do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end