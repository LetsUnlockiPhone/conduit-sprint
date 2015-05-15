require_relative 'base'

module Conduit::Driver::Sprint
  class CheckCoverage < Conduit::Driver::Sprint::Base
    wsdl_service        'QueryCsaService/v1'
    xsd                 'queryCsa/v2/queryCsaV2.xsd'
    operation           :query_csa_v2
    optional_attributes :city, :state, :zip, :zip4
  end
end
