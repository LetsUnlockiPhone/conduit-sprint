require 'spec_helper'

describe QueryDeviceInfo do
  let(:device_serial_number)     { '12345678901' }
  let(:creds) do
    credentials.merge(device_serial_number: device_serial_number)
  end

  let(:query_device) { QueryDeviceInfo.new(creds) }

  describe 'dec_query_device' do
    let(:unsigned_soap) do
      File.read('./spec/fixtures/requests/query_device_info/dec_unsigned_soap.xml')
    end

    let(:signed_soap) do
      File.read('./spec/fixtures/requests/query_device_info/dec_signed_soap.xml')
    end

    describe 'soap_xml' do
      subject { query_device.soap_xml }
      it      { should eq unsigned_soap }
    end

    describe 'signed_soap_xml' do
      subject { query_device.signed_soap_xml }
      it      { should eq signed_soap }
    end
  end

  describe 'hex_query_device' do
    let(:device_serial_number) { '12345678' }

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
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      QueryDeviceInfo.new(creds.merge(mock_status: :error))
    end
  end

  context 'a successful query device response is returned' do
    let(:serializable_hash) do 
      {
       :availability_type_code            => "1",
       :availability_type_message         => "Available",
       :device_serial_number              => "99000470382044",
       :device_type                       => "U",
       :equipment_freq_type_code          => "H",
       :freq_mode                         => "C",
       :iccid                             => "89011200000403604860",
       :imsi                              => "310120040360486",
       :model_name                        => "SAM L720T BLK XCVR SGL",
       :model_number                      => "SPHL720TB1",
       :manufacturer_name                 => "SAMSUNG",
       :not_available_reason_code         => "0",
       :uicc_availability_code            => "1",
       :uicc_availability_message         => "Available",
       :uicc_compatibility                => "Y",
       :uicc_not_available_reason_code    => "0",
       :uicc_type                         => "U",
       :validation_message                => "Device is valid and cleared for use",
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
