require_relative 'base'

module Conduit::Sprint::Decorators
  class TransferOwnershipDecorator < Base
    def code
      ownership_code || 'PLBL'
    end
  end
end
