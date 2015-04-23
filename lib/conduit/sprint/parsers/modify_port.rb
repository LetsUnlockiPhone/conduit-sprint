require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class ModifyPort::Parser < Parser::Base

    private

    def in_progress?
      true
    end
  end
end
