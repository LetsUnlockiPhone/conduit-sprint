require_relative 'base'

module Conduit::Driver::Sprint
  class ChangeNumber < Conduit::Driver::Sprint::Base
    wsdl_service        'WholesaleSwapSplitService/v1'
    xsd                 'WholesaleSwapSplit/v1/SwapSplitEnvelope.xsd'
    operation           :swap_mdn
    required_attributes :mdn
  end
end
