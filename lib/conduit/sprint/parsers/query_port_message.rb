require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class QueryPortMessage::Parser < Parser::Base
    attribute :message_type_code do
      content_for '//messageTypeCode'
    end

    attribute :message_type_description do
      content_for '//messageTypeDesc'
    end

    attribute :message_code do
      content_for '//messageCode'
    end    

    attribute :action_code do
      content_for '//actionCode'
    end

    attribute :response_type do
      content_for '//responseType'
    end

    attribute :delay_code do
      content_for '//delayCode'
    end

    attribute :reason_code do
      content_for '//reasonCode'
    end

    attribute :reason_text do
      content_for '//reasonText'
    end
  end
end
