require_relative 'base'

module Conduit::Driver::Sprint
  class TransferOwnership < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleDeviceManagementService/v1'
    xsd                 'manageDevicePhoneOwnership/v1/manageDevicePhoneOwnership.xsd'
    operation           :manage_device_phone_ownership
    required_attributes :nid
  end
end
