require 'conduit/sprint/serial_number_type_detector'
require 'street_address'
require 'delegate'
require 'forwardable'

module Conduit::Sprint::Decorators
  class Base < SimpleDelegator
    extend Forwardable

    def street_direction
      parsed_address1.prefix if !parsed_address1.blank?
    end

    def street_number
      parsed_address1.number if !parsed_address1.blank?
    end

    def street_name
      return if parsed_address1.blank?

      street      = !parsed_address1.street.blank? ? parsed_address1.street : ''
      street_type = !parsed_address1.street_type.blank? ? parsed_address1.street_type : ''
      (street + ' ' + street_type).strip
    end

    private

    def parsed_address1
      @parsed_address1 ||= StreetAddress::US.parse(address1, informal: true)
    end

    def serial_number_type_detector
      Conduit::Sprint::SerialNumberTypeDetector.new(meid) if meid
    end

    def meid?
      meid_hex? || meid_dec?
    end

    def esn?
      esn_hex? || esn_dec?
    end

    def meid_hex?
      serial_number_type_detector ? serial_number_type_detector.meid_hex? : false
    end

    def meid_dec?
      serial_number_type_detector ? serial_number_type_detector.meid_dec? : false
    end

    def esn_hex?
      serial_number_type_detector ? serial_number_type_detector.esn_hex? : false
    end

    def esn_dec?
      serial_number_type_detector ? serial_number_type_detector.esn_dec? : false
    end
  end
end
