require_relative 'base'

module Conduit::Driver::Sprint
  class QuerySubscription < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleSubscriptionDetailService/v1'
    operation           :wholesale_query_subscription_v4
    required_attributes :mdn
  end
end
