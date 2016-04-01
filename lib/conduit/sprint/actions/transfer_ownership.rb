require_relative 'base'

module Conduit::Driver::Sprint
  class TransferOwnership < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleDeviceManagementService/v1'
    xsd                 'manageDevicePhoneOwnership/v1/manageDevicePhoneOwnership.xsd'
    operation           :manage_device_phone_ownership
    required_attributes :meid
    optional_attributes :ownership_code

    def initialize(options = {})
      super

      if @options[:ownership_code] && !['PLBL', 'SPCS'].include?(@options[:ownership_code])
        raise ArgumentError,
          'Transfer code must be one of the following: PLBL, SPCS'
      end
    end

    def test_gateway
      "webservicesgatewaytest.sprint.com:444/#{test_environment}/services/mvno"
    end
  end
end
