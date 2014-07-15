require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class QueryCSA::Parser < Parser::Base
    attribute :csa do
      content_for '//csa'
    end
  end
end
