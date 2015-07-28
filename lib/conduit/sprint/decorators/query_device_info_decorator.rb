require_relative 'base'

module Conduit::Sprint::Decorators
  class QueryDeviceInfoDecorator < Base
    def meid
      device_serial_number.upcase unless device_serial_number.blank?
    end

    def icc_id
      iccid unless iccid.blank?
    end
  end
end
