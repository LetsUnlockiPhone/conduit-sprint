require_relative 'base'

module Conduit::Driver::Sprint
  class Change < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleSubscriptionModifyService/v1'
    xsd                 'wholesaleChangeServicePlans/v3/wholesaleChangeServicePlansV3.xsd'
    operation           :wholesale_change_service_plans_v3
    required_attributes :mdn
    optional_attributes :plan_code, :services_to_add, :services_to_remove
  end
end
