module Conduit::Sprint
  class MeidTypeDetector
    attr_reader :meid

    HEX_LENGTH = [8, 14]
    DEC_LENGTH = [11, 18]

    def initialize(meid)
      @meid = meid.to_s
    end

    def hex?
      HEX_LENGTH.include? @meid.length
    end

    def dec?
      DEC_LENGTH.include? @meid.length
    end
  end
end
