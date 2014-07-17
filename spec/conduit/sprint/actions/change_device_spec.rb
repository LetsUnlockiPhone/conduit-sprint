require 'spec_helper'

describe ChangeDevice do
  let(:change_device) { ChangeDevice.new(credentials.merge(mdn: '5555555555', nid: '123456789')) }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/change_device/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/change_device/signed_soap.xml')
  end

  let(:success) do
    File.read('./spec/fixtures/responses/change_device/success.xml')
  end

  describe 'soap_xml' do
    subject { change_device.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { change_device.signed_soap_xml }
    it      { should eq signed_soap }
  end

  context 'a successful change device response is returned' do
    let(:serializable_hash) do
      {
        :mdn     => "5555555555",
        :msid    => "0000011111111",
        :esn_dec => "999999999999",
        :msl     => "99999"
      }
    end
    
    before(:example) do
      savon.expects(:wholesale_swap_device_v2).
        with(signed_soap: signed_soap).returns(success)
    end

    subject                 { change_device.perform }
    it                      { should be_an_instance_of ChangeDevice::Parser }
    its(:xml)               { should eq success }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should eq serializable_hash }
  end
end
