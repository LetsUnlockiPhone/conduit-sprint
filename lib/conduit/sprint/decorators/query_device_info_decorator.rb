require_relative 'base'

module Conduit::Sprint::Decorators
  class QueryDeviceInfoDecorator < Base
    def icc_id
      iccid unless iccid.blank?
    end
  end
end
