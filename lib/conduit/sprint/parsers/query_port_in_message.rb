require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class QueryPortInMessage::Parser < Parser::Base
    attribute :messages do
      root.xpath('//accessNumberRecord').map do |port_message|
        {}.tap do |message|
          message[:access_number] = content_for('accessNumber', port_message)
          message[:port_due_date] = content_for('portDueDate', port_message)
          message[:port_status]   = content_for('portStatus', port_message)
        end
      end
    end
  end
end
