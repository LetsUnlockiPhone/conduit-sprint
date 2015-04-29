require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class QueryPortStatus::Parser < Parser::Base
    attr_accessor :status, :description, :message_code, :port_id

    attribute :status do
      @status
    end

    attribute :description do
      @description
    end

    attribute :message_code do
      @message_code
    end

    attribute :port_id do
      @port_id
    end

    def initialize(xml)
      super
      set_response_attributes
    end

    private

    def set_response_attributes
      port_messages = root.xpath('//wholesalePortMessageTypeInfo')
      port_messages.each do |port_message|
        @port_id              = content_for('portId', port_message)
        carrier_message_code  = content_for('messageCode', port_message)
        message_type_code     = content_for('messageTypeCode', port_message)
        
        if message_type_code == 'PTS'     # PTS = Port In Status
          action_code = content_for('actionCode', port_message)

          if action_code == 'ACT'
            @status = 'COMPLETED'
            break
          end
        elsif message_type_code == 'PIR'  # PIR = Port In Response
          response_type = content_for('responseType', port_message)

          if response_type == 'D'
            delay_code = content_for('delayCode', port_message)

            @status = 'DELAY'
            @description = delay_reasons[delay_code]
          elsif response_type == 'R'
            @status = 'RESOLUTION REQUIRED'
            @description = content_for('reasonCode', port_message)
            @message_code = content_for('reasonText', port_message)
          elsif response_type == 'C'
            port_request_number = content_for('portRequestNumber', port_message)

            @status = 'CONFIRMATION'
            @description = "Port request number #{port_request_number}"
          end
          break
        elsif message_type_code == 'PTC'
          @status = 'CANCELLED'
          @description = content_for('messageCode', port_message)
          @message_code = content_for('messageTypeCode', port_message)
          break
        elsif carrier_message_code == 'SUP3' # modify_port
          @status = 'CONFIRMATION'
          @description = 'Modify Port Submitted'
          break
        end
      end
    end

    def delay_reasons
      {
        '6G' => 'Port Complexity',
        '6H' => 'System Outage',
        '6J' => 'High Volume',
        '6L' => 'Request received outside of business hours',
      }
    end
  end
end
