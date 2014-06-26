require 'conduit/sprint'
require 'conduit/sprint/driver'
require 'savon/mock/spec_helper'

include Savon::SpecHelper

RSpec.configure do |config|
  config.before(:context) { savon.mock! }
  config.after(:context)  { savon.unmock! }
end
