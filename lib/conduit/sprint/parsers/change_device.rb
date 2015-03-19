require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class ChangeDevice::Parser < Parser::Base
    attribute :mdn
    attribute :msid

    attribute :nid do
      content_for '//serialNumber'
    end

    attribute :iccid do
      # Sprint does not pass back the iccid, let take it from the request options
      @options[:iccid]
    end

    attribute :msl do
      content_for '//masterSubsidyLock'
    end
  end
end
