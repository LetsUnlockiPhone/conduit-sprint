require_relative 'base'

module Conduit::Sprint::Decorators
  class ActivatePortDecorator < Base
    def port_mdn
      mdn.to_s.gsub(/\D/, '')
    end

    def authorized_by
      (first_name + ' ' + last_name).strip
    end
  end
end
