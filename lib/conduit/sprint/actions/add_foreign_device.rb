require_relative 'base'

module Conduit::Driver::Sprint
  class AddForeignDevice < Conduit::Driver::Sprint::Base
    wsdl_service        'DeviceManagementService/v1'
    xsd                 'addForeignDevice/v1/addForeignDevice.xsd'
    operation           :add_foreign_device
    required_attributes :device_serial_number, :consumer_id
    optional_attributes :part_number, :brand_code, :sku_type

    def test_gateway
      "webservicesgatewaytest.sprint.com:444/#{test_environment}/services/wireless/device"
    end
  end
end
