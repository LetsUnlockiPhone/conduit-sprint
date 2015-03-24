require 'conduit/sprint/nid_type_detector'
require 'street_address'
require 'delegate'
require 'forwardable'

module Conduit::Sprint::Decorators
  class Base < SimpleDelegator
    extend Forwardable

    def street_direction
      parsed_address1.prefix if parsed_address1
    end

    def street_number
      parsed_address1.number if parsed_address1
    end

    def street_name
      (parsed_address1.street + ' ' + parsed_address1.street_type).strip if parsed_address1
    end

    private

    def parsed_address1
      @parsed_address1 ||= StreetAddress::US.parse(address1, informal: true)
    end

    def nid_type_detector
      Conduit::Sprint::NidTypeDetector.new(nid) if nid
    end

    def nid_hex?
      nid_type_detector ? nid_type_detector.hex? : false
    end

    def nid_dec?
      nid_type_detector ? nid_type_detector.dec? : false
    end
  end
end
