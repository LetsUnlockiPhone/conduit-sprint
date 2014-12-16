require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class QueryDeviceInfo::Parser < Parser::Base
    attribute :model_name do
      content_for '//modelName'
    end

    attribute :model_number do
      content_for '//modelNumber'
    end

    attribute :manufacturer_name do
      content_for '//manufacturerName'
    end

    attribute :lte_iccid do
      content_for '//iccId'
    end

    attribute :lte_imsi do
      content_for '//imsi'
    end
  end
end
