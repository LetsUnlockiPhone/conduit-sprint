require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class Activate::Parser < Parser::Base
    attribute :mdn
    attribute :msid
    attribute :nai
    attribute :csa
    attribute :esn_dec do
      parent_node = containing_node_content('serialType', 'E')
      content_for('//serialNumber', parent_node)
    end
    attribute :iccid do
      return nil unless parent_node = containing_node_content('serialType', 'U')
      content_for('//serialNumber', parent_node)
    end
    attribute :lte_imsi do
      return nil unless parent_node = containing_node_content('serialType', 'U')
      content_for('//lteImsi', parent_node)
    end
    attribute :msl do
      content_for '//masterSubsidyLock'
    end
  end
end
