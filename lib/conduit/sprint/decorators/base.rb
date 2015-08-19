require 'conduit/sprint/meid_type_detector'
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

    def meid_type_detector
      Conduit::Sprint::MeidTypeDetector.new(meid) if meid
    end

    def small_meid?
      meid_type_detector ? meid_type_detector.small_meid? : false
    end

    def meid_hex?
      meid_type_detector ? meid_type_detector.hex? : false
    end

    def meid_dec?
      meid_type_detector ? meid_type_detector.dec? : false
    end
  end
end
