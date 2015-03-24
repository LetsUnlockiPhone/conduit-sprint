module Conduit::Sprint
  class NidTypeDetector
    attr_reader :nid

    HEX_LENGTH = [8, 14]
    DEC_LENGTH = [11, 18]

    def initialize(nid)
      @nid = nid.to_s
    end

    def hex?
      HEX_LENGTH.include? @nid.length
    end

    def dec?
      DEC_LENGTH.include? @nid.length
    end
  end
end
