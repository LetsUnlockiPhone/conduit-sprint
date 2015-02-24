require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class QueryDeviceInfo::Parser < Parser::Base
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

    attribute :uicc_compatibility do
      content_for '//uiccCompatibility'
    end

    attribute :uicc_availability_code do
      content_for '//uiccAvailabilityCode'
    end

    attribute :device_type do
      content_for '//deviceType'
    end

    attribute :equipment_freq_type_code do
      content_for '//equipmentFreqTypeCode'
    end

    attribute :uicc_not_available_reason_code do
      content_for '//uiccNotAvailableReasonCode'
    end

    attribute :not_available_reason_code do
      content_for '//notAvailableReasonCode'
    end

    attribute :device_serial_number do
      content_for '//deviceSerialNumber'
    end

    attribute :validation_message do
      content_for '//validationMessage'
    end
  end
end
