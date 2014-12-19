require_relative 'base'

module Conduit::Sprint::Decorators
  class ValidatePortDecorator < Base
    def port_mdn
      mdn.to_s.gsub(/\D/, '')
    end
  end
end
