require_relative 'base'

module Conduit::Driver::Sprint
  class ChangeDevice < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleSwapSplitService/v1'
    xsd                 'wholesaleSwapDevice/v2/wholesaleSwapDeviceV2.xsd'
    operation           :wholesale_swap_device_v2
    required_attributes :mdn, :nid
  end
end
