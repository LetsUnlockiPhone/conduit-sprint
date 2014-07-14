require_relative 'base'

module Conduit::Driver::Sprint
  class QueryCSA < Conduit::Driver::Sprint::Base
    wsdl_service        'QueryCsaService/v1'
    xsd                 'QueryCsa/v1/QueryCsaEnvelope.xsd'
    operation           :query_csa
    optional_attributes :street, :city, :state, :zip, :zip4
  end
end
