require 'conduit/sprint/version'
require 'conduit/sprint/request_mocker'
require 'conduit/sprint/decorators'
require 'conduit'

Conduit.configure do |config|
  config.driver_paths << File.join(File.dirname(__FILE__), 'sprint')
end
