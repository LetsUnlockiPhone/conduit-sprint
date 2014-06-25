require_relative 'base'

module Conduit::Driver::Sprint
  class Change < Conduit::Driver::Sprint::Base
    required_attributes :mdn
  end
end
