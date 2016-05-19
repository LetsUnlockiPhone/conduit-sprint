require_relative 'base'

module Conduit::Driver::Sprint
  class QueryPortInMessage < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleWnpService/v1'
    xsd                 'WholesaleWnp/v1/PortEnvelope.xsd'
    operation           :query_pending_reseller_port_ins
    optional_attributes :mdn
  end
end
