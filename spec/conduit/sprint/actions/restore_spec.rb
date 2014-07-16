require 'spec_helper'
include Conduit::Driver::Sprint

describe Restore do
  let(:restore) { Restore.new(credentials.merge(mdn: '5555555555')) }

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/restore/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/restore/signed_soap.xml')
  end

  let(:success) do
    File.read('./spec/fixtures/responses/restore/success.xml')
  end

  describe 'soap_xml' do    
    subject { restore.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { restore.signed_soap_xml }
    it      { should eq signed_soap }
  end

  context 'a successful restore response is returned' do
    before(:example) do
      savon.expects(:restore_subscription).
        with(signed_soap: signed_soap).returns(success)
    end

    subject                 { restore.perform }
    it                      { should be_an_instance_of Restore::Parser }
    its(:xml)               { should eq success }
    its(:response_status)   { should eq 'success' }
    its(:response_errors)   { should be_empty }
    its(:serializable_hash) { should be_empty }
  end
end