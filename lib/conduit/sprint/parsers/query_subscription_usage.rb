require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class QuerySubscriptionUsage::Parser < Parser::Base

    attribute :mdn
    attribute :from_date
    attribute :to_date
    attribute :usage_type
    attribute :total_calls
    attribute :total_airtime_usage
    attribute :are_more_call_details
    attribute :call_detail_list do
      root.xpath('//callDetailRecord').map do |call_detail_record|
        call_detail_record_attributes(call_detail_record)
      end
    end

    private

    def call_detail_record_attributes(record)
      {}.tap do |call_detail_record_attributes|
        call_detail_record_attributes[:airtime_minutes]              = content_for('airtimeMinutes', record)
        call_detail_record_attributes[:activity_unit]                = content_for('activityUnit', record)
        call_detail_record_attributes[:call_date]                    = content_for('callDate', record)
        call_detail_record_attributes[:call_time]                    = content_for('callTime', record)
        call_detail_record_attributes[:calling_number]               = content_for('callingNumber', record)
        call_detail_record_attributes[:called_destination]           = content_for('calledDestination', record)
        call_detail_record_attributes[:called_number]                = content_for('calledNumber', record)
        call_detail_record_attributes[:home_call]                    = content_for('homeCall', record)
        call_detail_record_attributes[:nai]                          = content_for('nai', record)
        call_detail_record_attributes[:rpdr_service_code]            = content_for('rpdrServiceCode', record)
        call_detail_record_attributes[:sid]                          = content_for('sid', record)
        call_detail_record_attributes[:usage_quantity]               = content_for('usageQuantity', record)
        call_detail_record_attributes[:usage_source_ind]             = content_for('usageSourceInd', record)
        call_detail_record_attributes[:content_type_name]            = content_for('contentTypeName', record)
        call_detail_record_attributes[:content_detailed_description] = content_for('contentDetailedDescription', record)
      end
    end
  end
end
