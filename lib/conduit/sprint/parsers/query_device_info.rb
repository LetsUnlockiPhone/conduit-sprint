require 'conduit/sprint/parsers/base'

module Conduit::Driver::Sprint
  class QueryDeviceInfo::Parser < Parser::Base

    AVAILABLE_CODES = {
      '0' => 'Not Available',
      '1' => 'Available'
    }

    DEVICE_TYPES = {
      'E' => 'CDMA ESN/MEID or embedded LTE',
      'U' => 'Removable transceiver / USIM transceiver'
    }

    ACTIVATION_STATUSES = {
      'Y' => 'Device is active',
      'N' => 'Device is inactive'
    }

    DEVICE_FED_MET_INDICATORS = {
      'true'  => 'FED is in the past, financial eligibility on the device has been met.',
      'false' => 'FED is in the future, financial eligibility on the device has not been met.'
    }

    POC_SWAP_INDICATORS = {
      'true'  => 'Device eligible for phone ownership change',
      'false' => 'Device is ineligible for phone ownership change'
    }

    UICC_COMPATIBILITY_DESCRIPTION = {
      'Y' => 'Transceiver and UICC are compatible together',
      'N' => 'The transceiver and UICC are not compatible'
    }

    UICC_TYPE_DESCRIPTION = {
      'U' => 'Removable USIM',
      'C' => 'Removable CSIM'
    }

    FREQUENCY_MODES = {
      'C' => 'CDMA',
      'D' => 'CDMA or AMPS',
      'A' => 'AMPS',
      'T' => 'TDMA',
      'S' => 'ACCESSORIES'
    }

    EQUIPMENT_FREQUENCY_TYPE_CODE_DESCRIPTIONS = {
      'P' => 'PCS',
      'C' => 'Cellular',
      'D' => 'PCS and Cellular',
      'K' => 'PCS with EVRC',
      'L' => 'PCS and Cellular with EVRC',
      'M' => 'Hybrid (Tri Mode)',
      'Y' => 'EVDO HANDSET',
      'S' => 'ACCESSORIES',
      'Z' => 'EVDO DATA CARD',
      'W' => 'EVDO HANDSET WITH ERI 2006',
      'E' => 'PCS & CELLULAR  EVRC – ERI 2006',
      'A' => '1XRTT EVDO BC10 BC14 WITH ERI 2011',
      'B' => 'ADVANCED WORLD-MODE PRL',
      'H' => 'SV-LTE WORLD MODE',
      'R' => 'DEVICES WITH PRL LIMITATIONS',
    }

    UICC_NOT_AVAILABLE_REASON_CODES = {
      '0' => 'Available',
      '1' => 'Stolen',
      '2' => 'In use',
      '3' => 'Fraudulent',
      '4' => 'Not in database',
      '5' => 'Reseller Partner ID is not correct',
      '6' => 'Pre-paid unprovisionable',
      '99' => 'Not available for activation'
    }

    attribute :activation_status do
      content_for '//activationStatus'
    end

    attribute :activation_status_description do
      ACTIVATION_STATUSES[content_for '//activationStatus']
    end

    attribute :device_fed_met_indicator do
      content_for '//deviceFedMetInd'
    end

    attribute :device_fed_met_indicator_description do
      DEVICE_FED_MET_INDICATORS[content_for '//deviceFedMetInd']
    end

    attribute :poc_swap_indicator do
      content_for '//pocSwapInd'
    end

    attribute :poc_swap_indicator_description do
      POC_SWAP_INDICATORS[content_for '//pocSwapInd']
    end

    attribute :model_name do
      content_for '//modelName'
    end

    attribute :model_number do
      content_for '//modelNumber'
    end

    attribute :manufacturer_name do
      content_for '//manufacturerName'
    end

    attribute :uicc_type do
      content_for '//uiccType'
    end

    attribute :uicc_type_description do
      UICC_TYPE_DESCRIPTION[content_for '//uiccType']
    end

    attribute :iccid do
      content_for '//iccId'
    end

    attribute :uicc_imsi do
      content_for '//uiccImsi'
    end

    attribute :uicc_sku do
      content_for '//uiccSku'
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

    attribute :uicc_compatibility_description do
      UICC_COMPATIBILITY_DESCRIPTION[content_for '//uiccCompatibility']
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

    attribute :device_type_description do
      DEVICE_TYPES[content_for '//deviceType']
    end

    attribute :freq_mode do
      content_for '//freqMode'
    end

    attribute :freq_mode_description do
      FREQUENCY_MODES[content_for '//freqMode']
    end

    attribute :equipment_freq_type_code do
      content_for '//equipmentFreqTypeCode'
    end

    attribute :equipment_freq_type_description do
      EQUIPMENT_FREQUENCY_TYPE_CODE_DESCRIPTIONS[content_for '//equipmentFreqTypeCode']
    end

    attribute :uicc_not_available_reason_code do
      content_for '//uiccNotAvailableReasonCode'
    end

    attribute :uicc_not_available_reason_message do
      UICC_NOT_AVAILABLE_REASON_CODES[content_for '//uiccNotAvailableReasonCode']
    end

    attribute :not_available_reason_code do
      content_for '//notAvailableReasonCode'
    end

    attribute :esn_meid_hex do
      content_for '//esnMeidHex'
    end

    attribute :validation_message do
      content_for '//validationMessage'
    end
  end
end
