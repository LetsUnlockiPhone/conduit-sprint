require_relative 'base'

module Conduit::Sprint::Decorators
  class CancelPortDecorator < Base
    def cancel_port_remark
      remark || 'cancel_port'
    end
  end
end
