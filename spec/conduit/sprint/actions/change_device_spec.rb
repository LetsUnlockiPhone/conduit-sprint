require 'spec_helper'

describe ChangeDevice do
  let(:change_device) { ChangeDevice.new(credentials.merge(mdn: '5555555555', nid: '123456789')) }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/change_device/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/change_device/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { change_device.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { change_device.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      ChangeDevice.new \
        credentials.merge(credentials.merge(mdn: '5555555555', nid: '123456789', mock_status: :error))
    end
  end

  context 'a successful change device response is returned' do
    subject                 { change_device.perform }
    it                      { should be_an_instance_of ChangeDevice::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should_not eq be_empty }
  end
end
