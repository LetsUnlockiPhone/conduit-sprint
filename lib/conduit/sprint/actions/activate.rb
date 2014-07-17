require_relative 'base'

module Conduit::Driver::Sprint
  class Activate < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleSubscriptionService/v1'
    xsd                 'wholesaleActivateSubscription/v4/wholesaleActivateSubscriptionV4.xsd'
    operation           :wholesale_activate_subscription_v4
    required_attributes :nid, :plan_code
    optional_attributes :csa, :zip, :service_codes
  end
end
