require_relative 'base'

module Conduit::Driver::Sprint
  class QueryPortMessage < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesalePortMessageService/v1'
    xsd                 'queryPortMessage/v1/queryPortMessage.xsd'
    operation           :query_port_message
    optional_attributes :mdn, :message_type_code, :reply_port_out_request,
                        :message_status_code, :start_date, :end_date
  end
end

# message_type_code:
# Provide to identify to query a specified message type.
#  
# EAI Message Type Codes
# POR - PortOutRequest
# DDT - DueDateTime
# PIR - PortInResponse
# PTS - PortStatus
# PTA - PortAbandonment
# PTN - PortNotifications
# PTC - PortCancel
# RPR - Reply PortOut Request

# message_status_code:
# Field is used to identify if an MVNO has responded to a PortOut request (either initial or supplemental)
#  
# Y indicates port out request has had a reply
# N indicates port out request that has not had a reply.
