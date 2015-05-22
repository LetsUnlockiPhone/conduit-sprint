require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class QueryDeviceInfo::Parser < Parser::Base

    AVAILABLE_CODES = {
      '0' => 'Not Available',
      '1' => 'Available'
    }

    NOT_AVAILABLE_CODES = {
      '1'  => 'Stolen',
      '2'  => 'In Use',
      '3'  => 'Fraudulent',
      '4'  => 'Not in database',
      '5'  => 'Owner = SPCS',
      '6'  => 'Pre-paid, unprovisionable',
      '7'  => 'In use with another MVNO',
      '8'  => 'Lost in CLWR',
      '9'  => 'Stolen in CLWR',
      '10' => 'Broken in CLWR',
      '11' => 'Blacklisted in CLWR',
      '12' => 'Reported lost/stolen by another carrier',
      '13' => 'Phone owner account ID mismatch Financial Eligiblity Date (FED) not met',
      '99' => 'Not available for activation'
    }

    attribute :model_name do
      content_for '//modelName'
    end

    attribute :model_number do
      content_for '//modelNumber'
    end

    attribute :manufacturer_name do
      content_for '//manufacturerName'
    end

    attribute :iccid do
      content_for '//iccId'
    end

    attribute :uicc_type do
      content_for '//uiccType'
    end

    attribute :imsi do
      content_for '//imsi'
    end

    attribute :availability_type_code do
      content_for '//availabilityTypeCode'
    end

    attribute :availability_type_message do
      AVAILABLE_CODES[content_for '//availabilityTypeCode']
    end

    attribute :uicc_compatibility do
      content_for '//uiccCompatibility'
    end

    attribute :uicc_availability_code do
      content_for '//uiccAvailabilityCode'
    end

    attribute :uicc_availability_message do
      AVAILABLE_CODES[content_for '//uiccAvailabilityCode']
    end    

    attribute :device_type do
      content_for '//deviceType'
    end

    attribute :freq_mode do
      content_for '//freqMode'
    end

    attribute :equipment_freq_type_code do
      content_for '//equipmentFreqTypeCode'
    end

    attribute :uicc_not_available_reason_code do
      content_for '//uiccNotAvailableReasonCode'
    end

    attribute :uicc_not_available_reason_message do
      NOT_AVAILABLE_CODES[content_for '//uiccNotAvailableReasonCode']
    end

    attribute :not_available_reason_code do
      content_for '//notAvailableReasonCode'
    end

    attribute :not_available_reason_message do
      NOT_AVAILABLE_CODES[content_for '//notAvailableReasonCode']
    end

    attribute :device_serial_number do
      content_for '//deviceSerialNumber'
    end

    attribute :validation_message do
      content_for '//validationMessage'
    end
  end
end
