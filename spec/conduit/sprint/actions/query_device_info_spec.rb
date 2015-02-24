require 'spec_helper'

describe QueryDeviceInfo do
  let(:query_device) { QueryDeviceInfo.new(credentials.merge(device_serial_number: '12345678901')) }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/query_device_info/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/query_device_info/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { query_device.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { query_device.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      QueryDeviceInfo.new(credentials.merge(device_serial_number: '12345678901', mock_status: :error))
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
       :not_available_reason_message      => nil,
       :uicc_availability_code            => "1",
       :uicc_availability_message         => "Available",
       :uicc_compatibility                => "Y",
       :uicc_not_available_reason_code    => "0",
       :uicc_not_available_reason_message => nil,
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
end
