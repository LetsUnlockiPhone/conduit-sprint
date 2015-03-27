require_relative 'base'

module Conduit::Driver::Sprint
  class QueryDeviceInfo < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleQueryDeviceInfoService/v1'
    xsd                 'wholesaleValidateDevice/v2/wholesaleValidateDeviceV2.xsd'
    operation           :wholesale_validate_device_v2
    required_attributes :device_serial_number
  end
end
