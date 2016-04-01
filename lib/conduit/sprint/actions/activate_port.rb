require_relative 'base'

module Conduit::Driver::Sprint
  class ActivatePort < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleWnpService/v1'
    xsd                 'wholesaleActivateSubscriptionWithPortIn/v4/wholesaleActivateSubscriptionWithPortInV4.xsd'
    operation           :wholesale_activate_subscription_with_port_in_v4
    required_attributes :meid, :mdn, :city, :state, :zip, :carrier_account, :plan_code
    optional_attributes :address1, :first_name, :last_name, :business_name,
                        :ssn, :tax_id, :carrier_password, :csa, :service_codes,
                        :iccid, :authorized_by

    def initialize(options = {})
      super
      @options[:csa] ||= lookup_csa_by_port_mdn
    end

    def perform
      claim_ownership! if @options[:claim_ownership]
      super
    end

    private

    def lookup_csa_by_port_mdn
      response = ValidatePort.new(validate_port_attributes).perform
      if response.response_status == 'success'
        response.csa
      else
        raise "Unable to lookup CSA by Mdn: #{@options[:mdn]}"
      end
    end

    def claim_ownership!
      response = TransferOwnership.new(transfer_ownership_attributes).perform
      if response.response_status == 'failure'
        raise "Unable to claim ownership of ESN: #{@options[:meid]}"
      end
    end

    def transfer_ownership_attributes
      credentials.merge(meid: @options[:meid],
                        mock_status: @options[:mock_status])
    end

    def validate_port_attributes
      credentials.merge(mdn: @options[:mdn], mock_status: @options[:mock_status])
    end
  end
end
