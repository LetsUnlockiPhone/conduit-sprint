require_relative 'base'

module Conduit::Sprint::Decorators
  class ActivatePortDecorator < Base
    def port_authorized_by
      if !authorized_by.blank?
        authorized_by
      elsif !first_name.blank? && !last_name.blank?
        (first_name + ' ' + last_name).strip
      end
    end
  end
end
