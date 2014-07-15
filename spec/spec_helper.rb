require 'rspec/its'
require 'conduit/sprint'
require 'conduit/sprint/driver'
include Conduit::Driver::Sprint

Dir[File.join(Dir.pwd, 'spec/support/**/*.rb')].each { |file| require file }
