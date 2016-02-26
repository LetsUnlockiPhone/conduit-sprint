require_relative 'base'

module Conduit::Sprint::Decorators
  class AddForeignDeviceDecorator < Base
    def meid
      device_serial_number.upcase unless device_serial_number.blank?
    end
  end
end
