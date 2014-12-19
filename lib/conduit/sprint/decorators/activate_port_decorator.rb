require_relative 'base'

module Conduit::Sprint::Decorators
  class ActivatePortDecorator < Base
    def authorized_by
      (first_name + ' ' + last_name).strip
    end
  end
end
