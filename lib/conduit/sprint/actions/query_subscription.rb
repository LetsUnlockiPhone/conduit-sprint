require_relative 'base'

module Conduit::Driver::Sprint
  class QuerySubscription < Conduit::Driver::Sprint::Base
    required_attributes :mdn

    def wsdl
      'https://webservicesgateway.sprint.com:444/services/mvno/WholesaleSubscriptionDetailService/v1?wsdl'
    end
  end
end
