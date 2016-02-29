require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class AddForeignDevice::Parser < Parser::Base
    attribute :available_reason_code
    attribute :available_reason_description
    attribute :model_number
  end
end
