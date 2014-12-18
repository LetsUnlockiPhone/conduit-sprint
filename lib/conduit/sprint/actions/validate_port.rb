require_relative 'base'

module Conduit::Driver::Sprint
  class ValidatePort < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleWnpService/v1'
    xsd                 'WholesaleWnp/v1/PortEnvelope.xsd'
    operation           :pre_validate_port
    required_attributes :mdn
  end
end
