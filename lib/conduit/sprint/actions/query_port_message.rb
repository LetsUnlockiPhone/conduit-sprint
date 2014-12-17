require_relative 'base'

module Conduit::Driver::Sprint
  class QueryPortMessage < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesalePortMessageService/v1'
    xsd                 'queryPortMessage/v1/queryPortMessage.xsd'
    operation           :query_port_message
    required_attributes :mdn
  end
end
