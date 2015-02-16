require_relative 'base'

module Conduit::Driver::Sprint
  class QueryDeviceInfo < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleQueryDeviceInfoService/v1'
    xsd                 'wholesaleValidateDevice/v1/wholesaleValidateDevice.xsd'
    operation           :wholesale_validate_device
    required_attributes :device_serial_number
  end
end
