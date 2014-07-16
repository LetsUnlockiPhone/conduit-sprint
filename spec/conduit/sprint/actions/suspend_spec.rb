require 'spec_helper'
include Conduit::Driver::Sprint

describe Suspend do
  let(:suspend) { Suspend.new(credentials.merge(mdn: '5555555555')) }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/suspend/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/suspend/signed_soap.xml')
  end

  let(:success) do
    File.read('./spec/fixtures/responses/suspend/success.xml')
  end

  describe 'soap_xml' do
    subject { suspend.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { suspend.signed_soap_xml }
    it      { should eq signed_soap }
  end

  context 'a successful suspend response is returned' do
    before(:example) do
      savon.expects(:suspend_subscription).
        with(signed_soap: signed_soap).returns(success)
    end

    subject                 { suspend.perform }
    it                      { should be_an_instance_of Suspend::Parser }
    its(:xml)               { should eq success }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should be_empty }
  end
end
