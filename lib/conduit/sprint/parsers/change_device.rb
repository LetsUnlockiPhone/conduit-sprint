require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class ChangeDevice::Parser < Parser::Base
    attribute :mdn
    attribute :msid

    attribute :esn_dec do
      content_for '//serialNumber'
    end

    attribute :msl do
      content_for '//masterSubsidyLock'
    end
  end
end
