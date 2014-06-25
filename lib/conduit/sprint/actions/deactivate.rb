require_relative 'base'

module Conduit::Driver::Sprint
  class Deactivate < Conduit::Driver::Sprint::Base
    required_attributes :mdn
  end
end
