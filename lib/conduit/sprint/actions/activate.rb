require_relative 'base'

module Conduit::Driver::Sprint
  class Activate < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleSubscriptionService/v1'
    xsd                 'wholesaleActivateSubscription/v4/wholesaleActivateSubscriptionV4.xsd'
    operation           :wholesale_activate_subscription_v4
    required_attributes :device_serial_number, :plan_code
    optional_attributes :csa, :zip, :service_codes, :claim_ownership, :iccid

    def initialize(options = {})
      super

      unless csa_present? || zip_present?
        raise ArgumentError,
          'You must provide one of the following attributes: csa, zip'
      end

      @options[:csa] ||= lookup_csa_by_zip
    end

    def perform
      claim_ownership! if @options[:claim_ownership]
      super
    end

    private

    def csa_present?
      !@options[:csa].nil? && !@options[:csa].empty?
    end

    def zip_present?
      !@options[:zip].nil? && !@options[:zip].empty?
    end

    def lookup_csa_by_zip
      response = CheckCoverage.new(csa_attributes).perform
      if response.response_status == 'success'
        response.csa
      else
        raise "Unable to lookup CSA by Zip Code: #{@options[:zip]}"
      end
    end

    def claim_ownership!
      response = TransferOwnership.new(transfer_ownership_attributes).perform
      if response.response_status == 'failure'
        raise "Unable to claim ownership of ESN: #{@options[:device_serial_number]}"
      end
    end

    def csa_attributes
      credentials.merge(zip: @options[:zip], mock_status: @options[:mock_status])
    end

    def transfer_ownership_attributes
      credentials.merge(device_serial_number: @options[:device_serial_number],
                        mock_status: @options[:mock_status])
    end
  end
end
