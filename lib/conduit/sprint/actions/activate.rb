require_relative 'base'

module Conduit::Driver::Sprint
  class Activate < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleSubscriptionService/v1'
    xsd                 'wholesaleActivateSubscription/v4/wholesaleActivateSubscriptionV4.xsd'
    operation           :wholesale_activate_subscription_v4
    required_attributes :nid, :plan_code
    optional_attributes :csa, :zip, :service_codes

    def initialize(options = {})
      super

      unless csa_present? || zip_present?
        raise ArgumentError,
          'You must provide one of the following attributes: csa, zip'
      end

      @options[:csa] ||= lookup_csa_by_zip      
    end

    private

    def csa_present?
      !@options[:csa].nil? && !@options[:csa].empty?
    end

    def zip_present?
      !@options[:zip].nil? && !@options[:zip].empty?
    end

    def lookup_csa_by_zip
      response = QueryCSA.new(csa_attributes).perform
      if response.response_status == 'success'
        response.csa
      else
        raise "Unable to lookup CSA by Zip Code: #{@options[:zip]}"
      end
    end

    def csa_attributes
      credentials.merge(zip: @options[:zip])
    end
  end
end
