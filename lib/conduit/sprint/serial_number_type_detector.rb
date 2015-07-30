module Conduit::Sprint
  class SerialNumberTypeDetector
    attr_reader :serial_number

    ESN_HEX_LENGTH  = 8
    ESN_DEC_LENGTH  = 11
    MEID_HEX_LENGTH = 14
    MEID_DEC_LENGTH = 18

    def initialize(serial_number)
      @serial_number = serial_number.to_s
    end

    def esn_hex?
      ESN_HEX_LENGTH == @serial_number.length
    end

    def esn_dec?
      ESN_DEC_LENGTH == @serial_number.length
    end

    def meid_hex?
      MEID_HEX_LENGTH == @serial_number.length
    end

    def meid_dec?
      MEID_DEC_LENGTH == @serial_number.length
    end

    def hex?
      meid_hex? || esn_hex?
    end

    def dec?
      meid_dec? || esn_dec?
    end

  end
end
