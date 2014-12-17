require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class QueryPortMessage::Parser < Parser::Base
    attribute :messages do
      root.xpath('//wholesalePortMessageTypeInfo').map do |port_message|
        {}.tap do |message|
          message[:message_type_code]        = content_for('messageTypeCode', port_message)
          message[:message_type_description] = content_for('messageTypeDesc', port_message)
          message[:message_code]             = content_for('messageCode', port_message)
          message[:action_code]              = content_for('actionCode', port_message)
          message[:response_type]            = content_for('responseType', port_message)
          message[:delay_code]               = content_for('delayCode', port_message)
          message[:reason_code]              = content_for('reasonCode', port_message)
          message[:reason_text]              = content_for('reason_text', port_message)
        end
      end
    end
  end
end
