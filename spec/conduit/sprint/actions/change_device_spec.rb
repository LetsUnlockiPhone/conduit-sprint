require 'spec_helper'

describe ChangeDevice do
  let(:change_device) { ChangeDevice.new(creds) }
  let(:mdn)           { '5555555555' }
  let(:meid)          { '12345678aaa' }
  let(:iccid)         { '30112000000123456789' }
  let(:creds)         { credentials.merge(mdn: mdn, meid: meid) }

  let(:unsigned_lte_soap) do
    File.read('./spec/fixtures/requests/change_device/unsigned_lte_soap.xml')
  end

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/change_device/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/change_device/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { change_device.soap_xml }
    it      { should eq unsigned_soap }

    context 'with iccid' do
      let(:creds) do
        credentials.merge(mdn: mdn, meid: meid, iccid: iccid)
      end
      it { should eq unsigned_lte_soap }
    end
  end

  describe 'signed_soap_xml' do
    subject { change_device.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      ChangeDevice.new \
        credentials.merge(credentials.merge(mdn: mdn, meid: meid, mock_status: :error))
    end
  end

  context 'a successful change device with meid response is returned' do
    subject                 { change_device.perform }
    it                      { should be_an_instance_of ChangeDevice::Parser }
    its(:response_status)   { should eq 'success' }
    its(:nid)               { should eq meid.upcase }
    its(:mdn)               { should eq mdn }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should_not eq be_empty }
  end

  context 'a successful change device with iccid response is returned' do
    let(:creds) do
      credentials.merge(mdn: mdn, meid: meid, iccid: iccid)
    end

    subject                 { change_device.perform }
    it                      { should be_an_instance_of ChangeDevice::Parser }
    its(:response_status)   { should eq 'success' }
    its(:nid)               { should eq meid.upcase }
    its(:mdn)               { should eq mdn }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should_not eq be_empty }
  end

  context 'a failed change device response is returned' do
    before do
      creds.merge!(mock_status: :failure)
    end

    let(:response_errors) do
      [
        Conduit::Error.new(code: "210820012",
          message: "The subscriber does not belong to the 2222333344 Major Account/MVNO"),
        Conduit::Error.new(code: "Server.704", message: "Application processing error")
      ]
    end

    subject                 { change_device.perform }
    it                      { should be_an_instance_of ChangeDevice::Parser }
    its(:response_status)   { should eq 'failure'}
    its(:response_errors)   { should eq response_errors }
  end
end
