require_relative 'base'

module Conduit::Driver::Sprint
  class Restore < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleSubscriptionModifyService/v1'
    xsd                 'WholesaleSubscriptionModify/v1/ModifySubscriptionEnvelope.xsd'
    operation           :restore_subscription
    required_attributes :mdn    
  end
end
