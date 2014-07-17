require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class TransferOwnership::Parser < Parser::Base
    attribute :phone_ownership_code
    attribute :manufacturer_name
    attribute :model_name
    attribute :model_number
  end
end
