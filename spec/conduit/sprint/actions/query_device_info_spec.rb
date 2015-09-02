require 'spec_helper'

describe QueryDeviceInfo do
  let(:device_serial_number)     { '123456789012345678' }
  let(:creds) do
    credentials.merge(
      device_serial_number: device_serial_number,
      iccid: '89011200000403604860'
    )
  end

  let(:query_device) { QueryDeviceInfo.new(creds) }

  describe 'dec_query_device' do
    let(:dec_unsigned_soap) do
      File.read('./spec/fixtures/requests/query_device_info/dec_unsigned_soap.xml')
    end

    let(:dec_signed_soap) do
      File.read('./spec/fixtures/requests/query_device_info/dec_signed_soap.xml')
    end

    describe 'soap_xml' do
      subject { query_device.soap_xml }
      it      { should eq dec_unsigned_soap }
    end

    describe 'signed_soap_xml' do
      subject { query_device.signed_soap_xml }
      it      { should eq dec_signed_soap }
    end
  end

  describe 'hex_query_device' do
    let(:device_serial_number) { '123456789ABCDE' }

    let(:hex_unsigned_soap) do
      File.read('./spec/fixtures/requests/query_device_info/hex_unsigned_soap.xml')
    end

    let(:hex_signed_soap) do
      File.read('./spec/fixtures/requests/query_device_info/hex_signed_soap.xml')
    end

    describe 'hex_soap_xml' do
      subject { query_device.soap_xml }
      it      { should eq hex_unsigned_soap }
    end

    describe 'hex_signed_soap_xml' do
      subject { query_device.signed_soap_xml }
      it      { should eq hex_signed_soap }
    end

    context 'with a lower case hex value' do
      let(:device_serial_number)     { '123456789abcde' }
      describe 'soap_xml' do
        subject { query_device.soap_xml }
        it      { should eq hex_unsigned_soap }
      end

      describe 'signed_soap_xml' do
        subject { query_device.signed_soap_xml }
        it      { should eq hex_signed_soap }
      end
    end
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      QueryDeviceInfo.new(creds.merge(mock_status: :error))
    end
  end

  context 'a successful query device response is returned' do
    let(:serializable_hash) do
      {
       :availability_type_code               => "1",
       :availability_type_message            => "Available",
       :esn_meid_hex                         => "99000250022761",
       :device_type                          => "U",
       :device_type_description              => "Removable transceiver / USIM transceiver",
       :equipment_freq_type_code             => "B",
       :equipment_freq_type_description      => "ADVANCED WORLD-MODE PRL",
       :freq_mode                            => "C",
       :freq_mode_description                => "CDMA",
       :iccid                                => "89011200000403604860",
       :uicc_imsi                            => "310120018850976",
       :uicc_sku                             => "CZ2101LTR",
       :model_name                           => "BST LG870 TRANSCEIVER SGL",
       :model_number                         => "LG870AB1",
       :manufacturer_name                    => "LG",
       :not_available_reason_code            => "0",
       :uicc_availability_code               => "1",
       :uicc_availability_message            => "Available",
       :uicc_compatibility                   => "Y",
       :uicc_not_available_reason_code       => "0",
       :uicc_not_available_reason_message    => "Available",
       :uicc_type                            => "U",
       :uicc_type_description                => "Removable USIM",
       :uicc_compatibility_description       => "Transceiver and UICC are compatible together",
       :validation_message                   => "Device is valid and cleared for use",
       :activation_status                    => "N",
       :activation_status_description        => "Device is inactive",
       :device_fed_met_indicator             => "true",
       :device_fed_met_indicator_description => "FED is in the past, financial eligibility on the device has been met.",
       :poc_swap_indicator                   => "true",
       :poc_swap_indicator_description       => "Device eligible for phone ownership change",
      }
    end

    subject                 { query_device.perform }
    it                      { should be_an_instance_of QueryDeviceInfo::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end

  context 'a failed query device response is returned' do
    before do
      creds.merge!(mock_status: :failure)
    end
    let(:device_serial_number)     { nil }

    let(:response_errors) do
      [
        { code: "210820012", message: "http://144.230.220.92:10002/services/WholesaleWnpService/v1: cvc-simple-type 1: element mdn value '11111111' is not a valid instance of type MobileDirectoryNumberString" },
        { code: "Client.705", message: "Input validation error" }
      ]
    end

    subject                 { query_device.perform }
    it                      { should be_an_instance_of QueryDeviceInfo::Parser }
    its(:response_status)   { should eq 'failure'}
    its(:response_errors)   { should eq response_errors }
  end
end
