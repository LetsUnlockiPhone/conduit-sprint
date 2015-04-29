require_relative 'base'

module Conduit::Sprint::Decorators
  class ModifyPortDecorator < Base
    def modify_port_remark
      remark || 'modify_port'
    end    
  end
end
