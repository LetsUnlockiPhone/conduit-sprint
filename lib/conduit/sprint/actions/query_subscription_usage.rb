require_relative 'base'

module Conduit::Driver::Sprint
  class QuerySubscriptionUsage < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleUsageInquiryService/v1'
    xsd                 'WholesaleUsageInquiry/v1/UsageInquiryEnvelope.xsd'
    operation           :query_subscription_usage
    optional_attributes :mdn, :meid, :esn, :device_serial_number, :from_date, :to_date, :usage_type
  end
end
