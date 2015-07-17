require_relative 'base'

module Conduit::Sprint::Decorators
  class QueryDeviceInfoDecorator < Base
    def meid
      device_serial_number.upcase
    end    
  end
end
