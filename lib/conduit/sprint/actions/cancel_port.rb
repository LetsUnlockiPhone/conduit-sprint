require_relative 'base'

module Conduit::Driver::Sprint
  class CancelPort < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleWnpService/v1'
    xsd                 'WholesaleWnp/v1/PortEnvelope.xsd'
    operation           :cancel_port
    optional_attributes :remark
    required_attributes :mdn
  end
end
