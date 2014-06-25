require 'spec_helper'
include Conduit::Driver::Sprint

describe QuerySubscription do
  let(:query_subscription) do
    QuerySubscription.new(
      mdn: '5555555555',
      application_id: '72993214',
      application_user_id: 'MOBILENET',
      cert: File.read('./spec/fixtures/security/cert.pem'),
      key: File.read('./spec/fixtures/security/key.pem')
    )
  end

  let(:unsigned_soap) do
    File.read('./spec/fixtures/requests/query_subscription/unsigned_soap.xml')
  end

  let(:signed_soap) do
    File.read('./spec/fixtures/requests/query_subscription/signed_soap.xml')
  end

  let(:soap_fault) do
    File.read('./spec/fixtures/responses/query_subscription/soap_fault.xml')
  end

  describe 'soap_xml' do
    subject { query_subscription.soap_xml }
    it      { should eq unsigned_soap }
  end

  describe 'signed_soap_xml' do
    subject { query_subscription.signed_soap_xml }
    it      { should eq signed_soap }
  end

  context 'when a SOAP fault is returned' do
    subject { query_subscription.perform }
    it      { should eq soap_fault }
  end
end