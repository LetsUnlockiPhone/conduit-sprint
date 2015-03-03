require_relative 'base'

module Conduit::Sprint::Decorators
  class TransferOwnershipDecorator < Base
    def code
      transfer_code || 'PLBL'
    end
  end
end
