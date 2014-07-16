require 'spec_helper'
include Conduit::Driver::Sprint

describe Hotline do
  let(:hotline) { Hotline.new(credentials.merge(mdn: '5555555555')) }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/hotline/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/hotline/signed_soap.xml')
  end

  let(:success) do
    File.read('./spec/fixtures/responses/hotline/success.xml')
  end

  describe 'soap_xml' do
    subject { hotline.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { hotline.signed_soap_xml }
    it      { should eq signed_soap }
  end

  context 'a successful hotline response is returned' do
    before(:example) do
      savon.expects(:suspend_subscription).
        with(signed_soap: signed_soap).returns(success)
    end

    subject                 { hotline.perform }
    it                      { should be_an_instance_of Hotline::Parser }
    its(:xml)               { should eq success }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should be_empty }
  end
end