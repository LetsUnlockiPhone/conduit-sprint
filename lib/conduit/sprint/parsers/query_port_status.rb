require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class QueryPortStatus::Parser < Parser::Base
    attr_accessor :status, :message, :message_code, :port_number

    attribute :status do
      @status
    end

    attribute :message do
      @message
    end

    attribute :message_code do
      @message_code
    end

    attribute :port_number do
      @port_number
    end

    def initialize(xml)
      super
      set_response_attributes
    end

    private

    def set_response_attributes
      port_messages = root.xpath('//wholesalePortMessageTypeInfo')
      port_messages.each do |port_message|
        @port_number          = content_for('portId', port_message)
        carrier_message_code  = content_for('messageCode', port_message)
        message_type_code     = content_for('messageTypeCode', port_message)
        
        if message_type_code == 'PTS'     # PTS = Port In Status
          action_code = content_for('actionCode', port_message)
          if action_code == 'ACT'
            handle_completed(port_message)
          end
          break
        elsif message_type_code == 'PIR'  # PIR = Port In Response
          response_type = content_for('responseType', port_message)

          if response_type == 'D'
            handle_delay(port_message)
          elsif response_type == 'R'
            handle_resolution_required(port_message)
          elsif response_type == 'C'
            handle_confirmation(port_message)
          end
          break
        elsif message_type_code == 'PTC'
          handle_cancelled(port_message)
          break
        elsif carrier_message_code == 'SUP3' # modify_port
          handle_modify(port_message)
          break
        end
      end
    end

    def handle_completed(port_message)
      @status = 'COMPLETED'
    end

    def handle_delay(port_message)
      delay_code = content_for('delayCode', port_message)

      @status = 'DELAY'
      @message = delay_reasons[delay_code]
    end

    def handle_resolution_required(port_message)
      @status = 'RESOLUTION REQUIRED'
      @message = content_for('reasonText', port_message)
      @message_code = content_for('reasonCode', port_message)
    end

    def handle_confirmation(port_message)
      port_request_number = content_for('portRequestNumber', port_message)

      @status = 'CONFIRMATION'
      @message = "Port request number #{port_request_number}"
    end

    def handle_cancelled(port_message)
      @status = 'CANCELLED'
      @message = content_for('messageCode', port_message)
      @message_code = content_for('messageTypeCode', port_message)
    end

    def handle_modify(port_message)
      @status = 'CONFIRMATION'
      @message = 'Modify Port Submitted'
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
