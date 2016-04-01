require_relative 'base'

module Conduit::Driver::Sprint
  class AddForeignDevice < Conduit::Driver::Sprint::Base
    wsdl_service        'DeviceManagementService/v1'
    xsd                 'addForeignDevice/v1/addForeignDevice.xsd'
    operation           :add_foreign_device
    required_attributes :meid
    optional_attributes :part_number, :brand_code, :sku_type, :consumer_id

    def initialize(options = {})
      super
      # Sprint wants a consumer_id in the api call, its the same as app_user_id
      @options[:consumer_id] ||= @options[:application_user_id]
    end

    def test_gateway
      "webservicesgatewaytest.sprint.com:444/#{test_environment}/services/wireless/device"
    end
  end
end
