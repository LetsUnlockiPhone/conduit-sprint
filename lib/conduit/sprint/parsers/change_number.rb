require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class ChangeNumber::Parser < Parser::Base
    attribute :new_mdn
    attribute :msid
  end
end
