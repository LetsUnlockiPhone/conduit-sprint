require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class QuerySubscription::Parser < Parser::Base
    attribute :reseller_partner_id
    attribute :mdn
    attribute :msid
    attribute :csa

    attribute :esn_dec do
      content_for '//deviceSerialNumber'
    end

    attribute :esn_hex do
      content_for '//esnMeidHex'
    end

    attribute :imsi do
      content_for '//lteImsi'
    end

    attribute :icc_id do
      content_for '//lteIccId'
    end

    attribute :activated_at do
      content_for '//activationDate'
    end

    attribute :status do
      content_for '//switchStatusCode'
    end

    attribute :plan_code do
      content_for '//pricePlanRecord//serviceCode'
    end

    attribute :plan_description do
      content_for '//pricePlanRecord//serviceDescription'
    end

    attribute :plan_effective_date do
      content_for '//pricePlanRecord//effectiveDate'
    end

    attribute :nai do
      content_for '//naiRecord//nai'
    end

    attribute :nai_effective_date do
      content_for '//naiRecord//effectiveDate'
    end

    attribute :nai_network_status_code do
      content_for '//naiRecord//networkStatusCode'
    end

    attribute :service_records do
      root.xpath('//serviceRecord').map do |service_record|
        service_record_attributes(service_record)
      end
    end

    private

    def service_record_attributes(service_record = {})
      {}.tap do |service_record_details|
        service_record_details[:service_code]        = content_for('serviceCode', service_record)
        service_record_details[:service_description] = content_for('serviceDescription', service_record)
        service_record_details[:effective_date]      = content_for('effectiveDate', service_record)
      end
    end
  end
end 
