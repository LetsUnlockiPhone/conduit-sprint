require_relative 'base'

module Conduit::Driver::Sprint
  class ChangeDevice < Conduit::Driver::Sprint::Base
    required_attributes :mdn, :nid
  end
end
