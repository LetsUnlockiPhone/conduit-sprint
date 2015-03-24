require_relative 'base'

module Conduit::Sprint::Decorators
  class TransferOwnershipDecorator < Base
    def code
      ownership_code || 'PLBL'
    end

    def nid
      device_serial_number
    end
  end
end
