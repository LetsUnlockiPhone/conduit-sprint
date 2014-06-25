require_relative 'base'

module Conduit::Driver::Sprint
  class Restore < Conduit::Driver::Sprint::Base
    required_attributes :mdn
  end
end
