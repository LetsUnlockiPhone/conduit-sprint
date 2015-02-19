require 'conduit/sprint/request_mocker/base'

module Conduit::Sprint::RequestMocker
  class Activate < Base
    def initialize(base, options = nil)
      @imsi = "310120" << rand(999999999).to_s.rjust(9, '0')
      super
    end
  end
end
