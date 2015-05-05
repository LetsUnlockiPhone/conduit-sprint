require_relative 'base'

module Conduit::Sprint::Decorators
  class ActivatePortDecorator < Base
    def port_authorized_by
      if authorized_by
        authorized_by
      elsif first_name && last_name
        (first_name + ' ' + last_name).strip
      end
    end
  end
end
