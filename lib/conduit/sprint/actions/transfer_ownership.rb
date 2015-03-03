require_relative 'base'

module Conduit::Driver::Sprint
  class TransferOwnership < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleDeviceManagementService/v1'
    xsd                 'manageDevicePhoneOwnership/v1/manageDevicePhoneOwnership.xsd'
    operation           :manage_device_phone_ownership
    required_attributes :nid
    optional_attributes :transfer_code

    def initialize(options = {})
      super

      if @options[:transfer_code] && !['PLBL', 'SPCS'].include?(@options[:transfer_code])
        raise ArgumentError,
          'Transfer code must be one of the following: PLBL, SPCS'
      end
    end
  end
end
