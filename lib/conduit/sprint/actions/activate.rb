require_relative 'base'

module Conduit::Driver::Sprint
  class Activate < Conduit::Driver::Sprint::Base
    required_attributes :nid
  end
end
