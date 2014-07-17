require_relative 'base'

module Conduit::Driver::Sprint
  class Deactivate < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleSubscriptionModifyService/v1'
    xsd                 'WholesaleSubscriptionModify/v1/ModifySubscriptionEnvelope.xsd'
    operation           :expire_subscription
    required_attributes :mdn
  end
end
