require 'spec_helper'

describe CancelPort do
  let(:cancel_port) { CancelPort.new(credentials.merge(mdn: '5555555555', remark: 'cancel port')) }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/cancel_port/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/cancel_port/signed_soap.xml')
  end

  describe 'soap_xml' do
    subject { cancel_port.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { cancel_port.signed_soap_xml }
    it      { should eq signed_soap }
  end

  it_should_behave_like 'a 500 error' do
    let(:action) do
      CancelPort.new(credentials.merge(mdn: '5555555555', mock_status: :error))
    end
  end

  context 'a successful cancel port response is returned' do
    subject                 { cancel_port.perform }
    it                      { should be_an_instance_of CancelPort::Parser }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
  end
end
